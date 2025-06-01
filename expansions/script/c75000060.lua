local m=75000060
local cm=_G["c"..m]
cm.name="「圣魔」纹章士-“碧风公主”"
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,cm.lcheck)
	c:EnableReviveLimit()
	--def down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.defval)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(cm.reccon)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.atkcon)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cm.defval(e,c)
	local rec=c:GetDefense()
	if rec<0 then rec=0 end
	return math.ceil(rec/2)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		local c1=e:GetHandler()
		local c2=g:GetFirst()
		if c1:IsRelateToEffect(e) and c2:IsControler(1-tp) and c1:IsPosition(POS_FACEUP_ATTACK) and not c2:IsImmuneToEffect(e)
			and c1:IsControler(tp) then
			Duel.CalculateDamage(c1,c2,true)
		end
	end
end
function cm.thfilter(c,e,tp)
	return ((c:IsSetCard(0x6752) and c:IsType(TYPE_MONSTER)) or c:IsCode(75000001))and c:IsAbleToHand() and c:IsFaceupEx()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end