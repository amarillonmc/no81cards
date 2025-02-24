if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=SNNM.ScreemTraps(c,s.got)
	e1:SetCondition(s.gcon)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.counterfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&0x4==0x4
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.counterfilter,1,nil) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0
end
function s.got(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCondition(s.lpcon)
	e1:SetOperation(s.lpop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(rp)
	Duel.SetLP(rp,lp-200)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAllTypes(0x20004)
end
function s.tgfilter(c,e,tp)
	return ((c:IsControler(tp) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()) or (c:IsControler(1-tp) and c:IsType(TYPE_MONSTER))) and c:IsCanBeEffectTarget(e)
end
function s.filter(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function s.fselect(g,tp,ct)
	if g:IsExists(Card.IsControler,1,nil,tp) then
		local c=g:GetFirst()
		return #g==1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
	else return #g<=ct and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_REMOVED,0,nil)
	local sg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then return ft>0 and sg:CheckSubGroup(s.fselect,1,math.min(#sg,ft),tp,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=sg:SelectSubGroup(tp,s.fselect,false,1,math.min(#sg,ft),tp,ct)
	Duel.SetTargetCard(tg)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<#g then return end
	local c=e:GetHandler()
	local res=g:GetFirst():IsType(TYPE_EQUIP)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if res then sg=sg:Filter(s.filter,nil,g:GetFirst()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqg=sg:Select(tp,1,1,nil)
	if #eqg<1 then return end
	Duel.HintSelection(eqg)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(0xc538)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
		if Duel.Equip(tp,tc,eqg:GetFirst(),true,true) and not res then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EQUIP_LIMIT)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetLabelObject(eqg:GetFirst())
			e2:SetValue(s.eqlimit)
			tc:RegisterEffect(e2,true)
		end
	end
	Duel.EquipComplete()
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
