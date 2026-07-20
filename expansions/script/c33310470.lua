--闭馆-装置艺术第1号“各位四散的肉与骨将化为观众席”
local s,id=GetID()
s.VHisc_HUANZHI=true

function s.initial_effect(c)
	--这个卡名的卡1回合只能发动1张
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--①：以场上另1张同名卡为对象，选择1个效果适用
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	--②：自己场上的「幻指」怪兽攻击力上升500
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end

--①
function s.spcheck(c,e,tp)
	return c:IsLocation(LOCATION_SZONE) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.tgfilter(c,e,tp)
	if not c:IsFaceup() or not c:IsCode(id) or c==e:GetHandler() then return false end
	return s.spcheck(c,e,tp) or c:IsDestructable()
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local b1=s.spcheck(tc,e,tp)
	local b2=tc:IsDestructable()

		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
		end

	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end

function s.placefilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE)>0
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsLocation(LOCATION_SZONE) or bit.band(tc:GetOriginalType(),TYPE_MONSTER)==0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

	else
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local g=Duel.GetMatchingGroup(s.placefilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,e)
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local p=sc:GetOwner()
		if not Duel.MoveToField(sc,tp,p,LOCATION_SZONE,POS_FACEUP,true) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_MSCHANGE)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_CODE)
		e2:SetValue(id)
		sc:RegisterEffect(e2)
		sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end

--②
function s.atktg(e,c)
	return c:IsFaceup() and c.VHisc_HUANZHI
end
