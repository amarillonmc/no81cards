local m=53764016
local cm=_G["c"..m]
cm.name="天土"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(function(e,c)return c:IsFacedown()end)
	e2:SetValue(POS_FACEUP_DEFENSE+NO_FLIP_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tktg)
	e3:SetOperation(cm.tkop)
	c:RegisterEffect(e3)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e3:SetLabelObject(sg)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetLabelObject(sg)
	e4:SetCondition(cm.tdcon)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
end
cm.has_text_type=TYPE_SPIRIT
function cm.GetLegalAttributesOnly(tp)
	local a,attr=1,0
	while a<ATTRIBUTE_ALL do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,2000,2000,1,RACE_WINDBEAST,a) then attr=attr|a end
		a=a<<1
	end
	return attr
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.GetLegalAttributesOnly(tp)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local attr=Duel.AnnounceAttribute(tp,1,cm.GetLegalAttributesOnly(tp))
	Duel.SetTargetParam(attr)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local attr=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not attr or attr==0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,2000,2000,1,RACE_WINDBEAST,attr) then return end
	local token1=Duel.CreateToken(tp,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(attr)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token1:RegisterEffect(e1,true)
	if Duel.SpecialSummon(token1,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local sg=e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		if c:GetFlagEffect(m)==0 then
			sg:Clear()
			c:RegisterFlagEffect(m,RESET_EVENT+0x1fc0000,0,1)
			sg:AddCard(token1)
		end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,2000,2000,1,RACE_WINDBEAST,attr,POS_FACEUP,1-tp) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local token2=Duel.CreateToken(tp,m+1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_ADD_ATTRIBUTE)
		e2:SetValue(attr)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token2:RegisterEffect(e2,true)
		if Duel.SpecialSummon(token2,0,tp,1-tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then sg:AddCard(token2) end
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0 and Group.__band(eg,e:GetLabelObject()):GetCount()>0
end
function cm.filter(c)
	return (c:IsType(TYPE_SPIRIT) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsTypeInText(c,TYPE_SPIRIT))) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then Duel.Draw(tp,1,REASON_EFFECT) end
end
