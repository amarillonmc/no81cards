local m=15005894
local cm=_G["c"..m]
cm.name="狂音主的信音·灵言单卡拉比"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sstg)
	e1:SetOperation(cm.ssop)
	c:RegisterEffect(e1)
	--reduce atk and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	aux.CreateMaterialReasonCardRelation(c,e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6f43)
end
function cm.ssfilter(c)
	return c:IsSetCard(0x6f43) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.ssfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local lg=e:GetHandler():GetLinkedGroup()
	if lg and lg:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(EFFECT_FLAG_DELAY)
	end
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.ssfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function cm.disfilter(c,e)
	return aux.NegateMonsterFilter(c) and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,rc)
	return g:IsContains(rc)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return rc:IsRelateToEffect(e) and g:CheckSubGroup(cm.fselect,2,2,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,rc)
	Duel.SetTargetCard(sg)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					tc:RegisterEffect(e3)
				end
			end
			tc=g:GetNext()
		end
	end
end