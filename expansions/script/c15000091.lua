local m=15000091
local cm=_G["c"..m]
cm.name="灵魂鸟-云雁"
function cm.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--to hand then Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and (Duel.IsExistingMatchingCard(cm.sum1filter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode()) or Duel.IsExistingMatchingCard(cm.sum2filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode()))
end
function cm.sum1filter(c,e,tp,code)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelBelow(4) and c:IsSummonable(true,nil) and not c:IsCode(code)
end
function cm.sum2filter(c,e,tp,code)
	return c:IsAbleToHand() and c:IsType(TYPE_SPIRIT) and c:IsLevelBelow(4) and c:IsSummonable(true,nil) and not c:IsCode(code)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 then
		local code=tc:GetCode()
		local ag=Duel.GetMatchingGroup(cm.sum1filter,tp,LOCATION_HAND,0,nil,e,tp,code)
		local bg=Duel.GetMatchingGroup(cm.sum2filter,tp,LOCATION_GRAVE,0,nil,e,tp,code)
		local x=114514
		if ag:GetCount()~=0 and bg:GetCount()==0 then x=1 end
		if bg:GetCount()~=0 and ag:GetCount()==0 then x=2 end
		if ag:GetCount()~=0 and bg:GetCount()~=0 then
			if Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0 then
				x=1
			else
				x=2
			end
		end
		Duel.BreakEffect()
		if x==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local ac=ag:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,ac,true,nil)
		end
		if x==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local bc=bg:Select(tp,1,1,nil):GetFirst()
			if Duel.SendtoHand(bc,nil,REASON_EFFECT)~=0 then
				Duel.Summon(tp,bc,true,nil)
			end
		end
	end
end