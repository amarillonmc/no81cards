--闪刀术式-轮舞
function c11513057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c11513057.condition)
	e1:SetTarget(c11513057.target)
	e1:SetOperation(c11513057.activate)
	c:RegisterEffect(e1)
end
function c11513057.cfilter(c)
	return c:GetSequence()<5
end 
function c11513057.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513057.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513057.xxfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x1115) 
end 
function c11513057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 
	if chk==0 then return Duel.IsExistingTarget(c11513057.xxfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.SelectTarget(tp,c11513057.xxfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end
function c11513057.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local x=1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then x=x+1 end 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,x,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then  
			Duel.BreakEffect() 
			Duel.Destroy(tc,REASON_EFFECT) 
		end 
	end 
end 



