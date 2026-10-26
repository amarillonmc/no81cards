--疯狂犯罪者·祖母
local s,id,o=GetID()
function s.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(3,id)
	e4:SetCondition(s.rtcon)
	e4:SetTarget(s.rttg)
	e4:SetOperation(s.rtop)
	c:RegisterEffect(e4)
end
function s.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and c:GetControler()~=tp and c:IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6A73) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=c:GetColumnGroup():Filter(s.cfilter,nil,tp)
	local atk=g:GetSum(Card.GetAttack)
	return -atk
end
function s.rfilter(c,tp)
	if not c:IsLocation(LOCATION_REMOVED) then return false end
	if not (c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE)) then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	if c:IsControler(1-tp) and not c:IsAbleToChangeControler() then return false end
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rfilter,1,nil,tp)
end
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.rfilter,nil,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINTMSG_DESTROY,tp,aux.Stringid(id,1))
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,g)
	end
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToChain() then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE-RESET_TOFIELD,0,1,c:GetFieldID())
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_SET_CONTROL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetLabel(c:GetFieldID())
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(function(se,sc) return sc:GetFlagEffect(id)>0 and se:GetLabel()==sc:GetFlagEffectLabel(id) end)
		e3:SetValue(tp)
		Duel.RegisterEffect(e3,tp)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,tc:GetPreviousPosition(),true)
	end
end