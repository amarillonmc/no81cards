local m=53755008
local cm=_G["c"..m]
cm.name="兔子小队急援"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(m)
	e5:SetRange(LOCATION_DECK)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			if g:IsExists(Card.IsHasEffect,1,nil,m) then
				if g:Filter(Card.IsHasEffect,nil,m):IsExists(Card.IsControler,1,nil,Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_PLAYER)) then Duel.SetChainLimit(function(e,rp,tp)return tp==rp end) end
			end
			return cm[0](tp,ct)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.spfilter(c,tp,...)
	local res=false
	local s={...}
	for _,seq in ipairs(s) do if Duel.CheckLocation(tp,LOCATION_MZONE,seq) then res=true end end
	return c:IsSetCard(0x5536) and c:IsSpecialSummonable(0) and res
end
function cm.filter1(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=eg:Filter(cm.filter1,nil,tp)
		local s={}
		for tc in aux.Next(g) do table.insert(s,4-tc:GetSequence()) end
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,tp,table.unpack(s))
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.filter2(c,e,tp)
	return c:IsControler(1-tp) and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,e,tp)
	local z,s=0,{}
	for tc in aux.Next(g) do
		z=z|(1<<(4-tc:GetSequence()))
		table.insert(s,4-tc:GetSequence())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,tp,table.unpack(s)):GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetValue(function(e,c,fp,rp,r)return z end)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(cm.tgval)
	e2:SetReset(RESET_EVENT+0xff0000)
	tc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.tgval)
	e3:SetValue(cm.ctval)
	tc:RegisterEffect(e3,true)
	Duel.SpecialSummonRule(tp,tc,0)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetOperation(cm.checkop)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_NEGATED)
	e5:SetLabelObject(e4)
	e5:SetOperation(cm.rstop)
	Duel.RegisterEffect(e5,tp)
end
function cm.tgtg(e,c)
	return c:IsControler(1-e:GetHandler():GetControler()) and e:GetHandler():GetColumnGroup():IsContains(c)
end
function cm.tgval(e,c)
	return c~=e:GetHandler()
end
function cm.ctval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and e:GetHandler():GetColumnGroup():IsContains(rc)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsAbleToDeck() then
		Duel.HintSelection(Group.FromCards(c))
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT) end
	end
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
