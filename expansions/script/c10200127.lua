function c10200127.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200127,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10200127.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200127,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200127)
	e2:SetTarget(c10200127.tg2)
	e2:SetOperation(c10200127.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c10200127.aclimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200127,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10200127.con4)
	e4:SetTarget(c10200127.tg4)
	e4:SetOperation(c10200127.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10200127.con5)
	e5:SetOperation(c10200127.op5)
	c:RegisterEffect(e5)
	if not c10200127.global_check then
		c10200127.global_check=true
		c10200127.spell_types_activated={}
		c10200127.spell_types_activated[0]=0
		c10200127.spell_types_activated[1]=0
		c10200127.activated_names={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c10200127.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c10200127.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
-- global
function c10200127.get_spell_type(ctype)
	if ctype&TYPE_SPELL==0 then return 0 end
	if ctype&TYPE_EQUIP~=0 then return TYPE_EQUIP end
	if ctype&TYPE_FIELD~=0 then return TYPE_FIELD end
	if ctype&TYPE_QUICKPLAY~=0 then return TYPE_QUICKPLAY end
	if ctype&TYPE_RITUAL~=0 then return TYPE_RITUAL end
	if ctype&TYPE_CONTINUOUS~=0 then return TYPE_CONTINUOUS end
	return 1
end
function c10200127.checkop(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	if not c10200127.activated_names[code] then c10200127.activated_names[code]=true end
	if re:IsActiveType(TYPE_SPELL) then
		local stype=c10200127.get_spell_type(re:GetActiveType())
		if stype~=0 then
			c10200127.spell_types_activated[rp]=c10200127.spell_types_activated[rp]|stype
		end
	end
end
function c10200127.clearop(e,tp,eg,ep,ev,re,r,rp)
	c10200127.spell_types_activated[0]=0
	c10200127.spell_types_activated[1]=0
	c10200127.activated_names={}
end
function c10200127.count_bits(n)
	local count=0
	local bits={1,TYPE_EQUIP,TYPE_FIELD,TYPE_QUICKPLAY,TYPE_RITUAL,TYPE_CONTINUOUS}
	for _,b in ipairs(bits) do
		if (n&b)~=0 then count=count+1 end
	end
	return count
end
-- 1
function c10200127.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c10200127.count_bits(c10200127.spell_types_activated[tp])>=3
end
-- 2
function c10200127.filter2(c,stype)
	local ctype=c:GetType()
	if stype==TYPE_FIELD then
		return ctype&TYPE_SPELL~=0 and ctype&TYPE_FIELD~=0 and c:IsSSetable(true)
	elseif stype==1 then
		return ctype&TYPE_SPELL~=0 and ctype&(TYPE_EQUIP|TYPE_FIELD|TYPE_QUICKPLAY|TYPE_RITUAL|TYPE_CONTINUOUS)==0 and c:IsSSetable()
	else
		return ctype&TYPE_SPELL~=0 and ctype&stype~=0 and c:IsSSetable()
	end
end
function c10200127.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return false end
		return Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,1)
			and Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,TYPE_CONTINUOUS)
			and Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,TYPE_RITUAL)
			and Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,TYPE_QUICKPLAY)
			and Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,TYPE_FIELD)
			and Duel.IsExistingMatchingCard(c10200127.filter2,tp,LOCATION_DECK,0,1,nil,TYPE_EQUIP)
	end
end
function c10200127.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return end
	local g=Group.CreateGroup()
	local field_card=nil
	local stypes={1,TYPE_CONTINUOUS,TYPE_RITUAL,TYPE_QUICKPLAY,TYPE_EQUIP,TYPE_FIELD}
	for _,stype in ipairs(stypes) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c10200127.filter2,tp,LOCATION_DECK,0,1,1,nil,stype):GetFirst()
		if tc then
			if stype==TYPE_FIELD then
				field_card=tc
			else
				g:AddCard(tc)
			end
		end
	end
	if #g==5 and field_card then
		Duel.SSet(tp,g)
		Duel.MoveToField(field_card,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
	end
end
-- 3
function c10200127.aclimit(e,re,tp)
	local code=re:GetHandler():GetCode()
	return code~=10200127 and c10200127.activated_names[code]
end
-- 4
function c10200127.con4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c10200127.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local stype=c10200127.get_spell_type(re:GetActiveType())
	if chk==0 then
		if stype==0 then return false end
		local flag=10200127*10+stype
		return Duel.GetFlagEffect(tp,flag)==0
	end
	local flag=10200127*10+stype
	Duel.RegisterFlagEffect(tp,flag,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,10200127,RESET_PHASE+PHASE_END,0,1)
end
function c10200127.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		local count=Duel.GetFlagEffect(tp,10200127)
		if count>=1 then
			Duel.Damage(1-tp,300,REASON_EFFECT)
		end
		if count==2 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
			c:RegisterFlagEffect(10200127,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200127,4))
		elseif count==3 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
			c:RegisterFlagEffect(10200127,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200127,5))
		elseif count==4 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(c10200127.efilter4)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
			c:RegisterFlagEffect(10200127,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200127,6))
		elseif count==5 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(0,LOCATION_ONFIELD)
			e3:SetTarget(c10200127.distg4)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			c:RegisterFlagEffect(10200127,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200127,7))
		elseif count==6 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e3:SetTargetRange(0,1)
			e3:SetValue(1)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			c:RegisterFlagEffect(10200127,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10200127,8))
		end
	end
end
function c10200127.efilter4(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10200127.distg4(e,c)
	return c:IsFaceup()
end
-- 5
function c10200127.con5(e,tp,eg,ep,ev,re,r,rp)
	return c10200127.count_bits(c10200127.spell_types_activated[tp])<=2
end
function c10200127.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10200127)
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
