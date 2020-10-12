function c82221065.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--lv change  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221065,0))  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,82221065)   
	e1:SetTarget(c82221065.lvtg)  
	e1:SetOperation(c82221065.lvop)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221065,1))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,82231065)  
	e2:SetTarget(c82221065.destg)  
	e2:SetOperation(c82221065.desop)  
	c:RegisterEffect(e2)   
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221065,2))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,82241065)  
	e3:SetCost(c82221065.spcost)  
	e3:SetTarget(c82221065.sptg)  
	e3:SetOperation(c82221065.spop)  
	c:RegisterEffect(e3) 
end  
function c82221065.lvfilter(c)  
	return c:IsFaceup() and not c:IsLevel(7) and c:IsLevelAbove(1)  
end  
function c82221065.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82221065.lvfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82221065.lvfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,c82221065.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82221065.lvop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetValue(7)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
	end  
end  
function c82221065.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)  
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)  
end  
function c82221065.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()>0 then 
		Duel.Destroy(tg,REASON_EFFECT)  
	end  
end  
function c82221065.spfilter(c)  
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end   
function c82221065.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221065.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,2,nil) end  
	local sg=Duel.SelectMatchingCard(tp,c82221065.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end  
function c82221065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end  
function c82221065.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  