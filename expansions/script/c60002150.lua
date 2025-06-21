--森罗万象的爱
local m=60002150
local cm=_G["c"..m]
function cm.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.rectg)
	e1:SetOperation(cm.recop)
	c:RegisterEffect(e1)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.thfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,60002150,RESET_PHASE+PHASE_END,0,1)
	local x=Duel.GetFlagEffect(tp,60002150)
	if math.floor(x/3)==x/3 then  ---0
		local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		for i=1,g2 do
			local gm=g1:GetFirst()
			if Card.IsCanAddCounter(gm,0x624,1) and gm:IsFaceup() then
				gm:AddCounter(0x624,1)
			end
			g1:RemoveCard(g1:GetFirst())
		end
	elseif math.floor((x/3)+0.5)==math.floor(x/3)+1 then ---2
		Duel.Draw(tp,1,REASON_EFFECT)
	else ---1
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end