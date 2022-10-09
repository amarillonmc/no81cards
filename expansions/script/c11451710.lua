--初醒之斗争军势
local cm,m=GetID()
function cm.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(cm.dccon)
	c:RegisterEffect(e1)
	--hand tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e2:SetRange(LOCATION_HAND)
	e2:SetLabelObject(c)
	e2:SetTarget(function(e,c) return c==e:GetLabelObject() end)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(cm.dccon)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cacost)
	e4:SetTarget(cm.catg)
	e4:SetOperation(cm.caop)
	c:RegisterEffect(e4)
end
function cm.dccon(e,c)
	return c:IsRace(RACE_MACHINE) and c~=e:GetHandler()
end
function cm.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,1-tp,REASON_COST)
end
function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.pfilter(c,tc)
	local attr=c:GetAttribute()
	return c:IsFaceup() and ((tc:IsCode(11451538) and attr&0x30>0) or (tc:IsCode(11451539) and attr&0x3>0) or (tc:IsCode(11451540) and attr&0xc>0))
end
function cm.setfilter(c,tp)
	return c:IsSSetable() and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function cm.tgfilter(c,attr)
	return c:IsAttribute(attr) and c:IsLevel(10) and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local hg=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_MZONE,0,nil,tc)
		local attr=0
		for hc in aux.Next(hg) do
			local attr2=hc:GetAttribute()
			attr=attr|attr2
		end
		local attr2=0
		if tc:IsCode(11451538) then attr2=0x30 end
		if tc:IsCode(11451539) then attr2=0x3 end
		if tc:IsCode(11451540) then attr2=0xc end
		if attr&attr2~=attr2 then attr=attr2&(~attr) end
		local tg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil,attr)
		if Duel.SSet(tp,g:GetFirst())>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			tg=tg:Select(tp,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end