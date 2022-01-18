--术结天缘 古洛夫拉菲
function c67200433.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5671),5,2)  
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200433)
	e1:SetTarget(c67200433.chtg)
	e1:SetOperation(c67200433.chop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--send to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200433,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,67200434)
	e5:SetTarget(c67200433.thtg)
	e5:SetOperation(c67200433.thop)
	c:RegisterEffect(e5)	
	--leave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(67200433,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c67200433.pencon)
	e6:SetTarget(c67200433.pentg)
	e6:SetOperation(c67200433.penop)
	c:RegisterEffect(e6)
end
c67200433.pendulum_level=5
--
function c67200433.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c67200433.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c67200433.filter,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=eg:Filter(c67200433.filter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200433.efilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e) and not c:IsType(TYPE_TOKEN)
end
function c67200433.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c67200433.efilter,nil,e)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(c,sg)
	end
end
--
function c67200433.thfilter2(c,e,tp)  
	return c:IsSetCard(0x5671) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end  
function c67200433.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200433.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end  
function c67200433.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c67200433.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end
	Duel.BreakEffect()
	local mg=c:GetOverlayGroup()
	if mg:GetCount()>0 then 
		Duel.Overlay(g:GetFirst(),mg) 
	end
end
--
function c67200433.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200433.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200433.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

