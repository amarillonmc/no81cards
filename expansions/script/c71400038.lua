--锖
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c71400038.target)
	e1:SetOperation(c71400038.activate)
	e1:SetDescription(aux.Stringid(71400038,0))
	e1:SetCountLimit(1,71400038+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400038.filter1r(c)
	return c:IsSetCard(0xd714) and c:IsAbleToRemove()
end
function c71400038.filter1t(c)
	return c:IsFaceup() and c:IsSetCard(0x3714) and c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function c71400038.filter1c(c)
	return c:IsOnField() and c:IsFacedown()
end
function c71400038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c71400038.filter1r,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 and c71400038.filter1t(fc) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c71400038.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,71400038,0,0,0)
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71400038.filter1r),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,4,4)
	aux.GCheckAdditional=nil
	if rg:GetCount()~=4 then return end
	local cg=rg:Filter(c71400038.filter1c,nil)
	if cg:GetCount()>0 then Duel.ConfirmCards(1-tp,cg) end
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=4 then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)<1 then return end
	--limit and disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c71400038.aclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c71400038.disable)
	Duel.RegisterEffect(e2,tp)
	--lp loss
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c71400038.ctop)
	Duel.RegisterEffect(e3,tp)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c71400038.mtop)
	Duel.RegisterEffect(e4,tp)
end
function c71400038.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0xc714)
end
function c71400038.disable(e,c)
	return c:IsSetCard(0xc714) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c71400038.filter1c(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousSetCard(0x714) and c:IsControler(tp)
end
function c71400038.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c71400038.filter1c,nil,tp)
	if ct>0 then
		Duel.SetLP(tp,Duel.GetLP(tp)-ct*300)
	end
end
function c71400038.filter1s(c)
	return c:IsSetCard(0x714) and not c:IsSetCard(0xc714) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c71400038.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and #g-fc<=ft
end
function c71400038.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71400038.filter1s),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,c71400038.gselect,false,1,math.min(2,ft+1),ft)
	if Duel.SSet(tp,tg)==0 then return end
	for tc in aux.Next(g) do
		--indestructable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		e1:SetDescription(aux.Stringid(71400038,1))
		tc:RegisterEffect(e1)
		--cannot inactivate/diseffect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		--cannot disable
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_DISABLE)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
	end
end