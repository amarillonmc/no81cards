--梦超时空战斗机-幽香
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	c:EnableCounterPermit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(s.pccon)
	e3:SetTarget(s.pctg)
	e3:SetOperation(s.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,6))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(s.bombcost)
	e4:SetTarget(s.bombtg)
	e4:SetOperation(s.bombop)
	c:RegisterEffect(e4)
	eflist={{"power_capsule",e3},{"bomb",e4}}
	s[c]=eflist
	
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
		e:GetHandler():AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	end
end
function s.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function s.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function s.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.pcfilter,1,nil,1-tp)
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Equip(tp,tc,c)
	end
end
function s.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST)
end
function s.desfilter(c,f)
	return f:IsExists(s.desfilter1,1,nil,c)
end
function s.desfilter1(c,tc)
	return c:GetColumnGroup():IsContains(tc)
end
function s.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()) end
	local f=tama.cosmicFighters_getFormation(c)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,f)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.rfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function s.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
end
function s.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(id,6))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e4)
	
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsFacedown()
			and Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then
			local token=Duel.CreateToken(tp,TAMA_OPTION_CODE)
			c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.tokenatk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(s.tokendef)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(s.tokenlv)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_RACE)
			e4:SetValue(s.tokenrace)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e5:SetValue(s.tokenatt)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e5,true)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_SELF_DESTROY)
			e6:SetCondition(s.tokendes)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e6,true)
			Duel.SpecialSummonComplete()
			c:SetCardTarget(token)
		end
	
		local f=tama.cosmicFighters_getFormation(c)
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,f)
		local tc=g:GetFirst()
		if g:GetCount()>0 then
			while tc do
				if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)
					end
					Duel.AdjustInstantly()
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				end
				tc=g:GetNext()
			end
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function s.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function s.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function s.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function s.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function s.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
