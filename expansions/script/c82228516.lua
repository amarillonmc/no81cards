function c82228516.initial_effect(c)  
	--xyz summon  
	c:EnableReviveLimit()  
	aux.AddXyzProcedureLevelFree(c,c82228516.mfilter,c82228516.xyzcheck,2,99)  
	--cannot be X material  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)  
	e1:SetValue(1)  
	c:RegisterEffect(e1)  
	--atk/def
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(c82228516.val)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)  
	--spsummon  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(82228516,0))  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,82228516)  
	e4:SetCost(c82228516.cost)  
	e4:SetTarget(c82228516.target)  
	e4:SetOperation(c82228516.operation)  
	c:RegisterEffect(e4)  
	--special summon  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(82228516,1))  
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetProperty(EFFECT_FLAG_DELAY)  
	e5:SetCode(EVENT_TO_GRAVE)  
	e5:SetCondition(c82228516.con2)  
	e5:SetTarget(c82228516.tg2)  
	e5:SetOperation(c82228516.op2)  
	c:RegisterEffect(e5)  
end  
function c82228516.mfilter(c,xyzc)  
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x291)  
end  
function c82228516.xyzcheck(g)  
	return g:GetClassCount(Card.GetRank)==1  
end  
function c82228516.val(e,c)  
	return c:GetOverlayCount()*200  
end  
function c82228516.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local rt=g:GetCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,rt,REASON_COST) end 
	c:RemoveOverlayCard(tp,rt,rt,REASON_COST)  
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end  
function c82228516.filter(c,e,tp)  
	return c:IsSetCard(0x291) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end 
function c82228516.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	local val=math.min(ft,ct)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82228516.filter(chkc,e,tp) end  
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c82228516.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then val=1 else end
	local g=Duel.SelectTarget(tp,c82228516.filter,tp,LOCATION_GRAVE,0,1,val,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end  
function c82228516.operation(e,tp,eg,ep,ev,re,r,rp)  
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if rg:GetCount()>0 then  
	Duel.SpecialSummon(rg,nil,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end  
function c82228516.con2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end  
function c82228516.filter2(c,e,tp)  
	return c:IsSetCard(0x291) and c:IsType(TYPE_XYZ) and not c:IsCode(82228516) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82228516.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0  
		and Duel.IsExistingMatchingCard(c82228516.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function c82228516.op2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228516.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
		local c=e:GetHandler()  
		if c:IsRelateToEffect(e) then  
			Duel.Overlay(tc,Group.FromCards(c))  
		end  
	end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(c82228516.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end  
function c82228516.splimit(e,c)  
	return not c:IsType(TYPE_XYZ)  
end  
