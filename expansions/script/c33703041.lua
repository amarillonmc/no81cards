--卜算现实
local m=33703041
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,33703041)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--confirm deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1,98715424)
	e2:SetCondition(cm.cfcon)
	e2:SetTarget(cm.cftg)
	e2:SetOperation(cm.cfop)
	c:RegisterEffect(e2)
	--remove counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.con)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.addc)
	c:RegisterEffect(e3)
	
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.SelectYesNo(1-tp,aux.Stringid(m,4)) then
	Duel.ShuffleDeck(tp)
	end
	local temp = Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	if temp ==0 then
	Duel.Damage(1-tp,6000,REASON_EFFECT)
	elseif temp ==1 then
	Duel.Recover(tp,6000,REASON_EFFECT)
	elseif temp == 2  then
	Duel.Draw(tp,2,REASON_EFFECT)
	elseif temp==3 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2 then
	Duel.DiscardHand(1-tp,cm.filter,2,2,REASON_EFFECT,nil,tp)
	end
end
function cm.filter(c,e,tp)
	return c:IsLocation(LOCATION_HAND)
end
function cm.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function cm.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.cfop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetLabel(ac)
	e1:SetOperation(cm.drawop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
	if r~=REASON_RULE then return end
	Duel.ConfirmCards(1-tp,eg)
	local g=eg:Filter(Card.IsCode,nil,e:GetLabel())
	if g:GetFirst() ~=nil then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	--Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end