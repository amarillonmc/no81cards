--超时空战斗机-大刀β
local m=13257304
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function c13257304.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.necon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.netg)
	e1:SetOperation(cm.neop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.pccon)
	e2:SetTarget(cm.pctg)
	e2:SetOperation(cm.pcop)
	c:RegisterEffect(e2)
	--[[
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)]]
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={{"power_capsule",e2}}
	cm[c]=eflist
	
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and Duel.GetTurnPlayer()==tp
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x351) and c:IsAbleToHandAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsCode(m)
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.Equip(tp,tc,c)
			end
		end
		Duel.NegateActivation(ev)
	end
end
function cm.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(m,2) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,3) n1[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==2 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,TAMA_OPTION_CODE,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,TAMA_OPTION_CODE)
		c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cm.tokenatk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(cm.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(cm.tokenlv)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(cm.tokenrace)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(cm.tokenatt)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(cm.tokendes)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6,true)
		c:SetCardTarget(token)
		Duel.SpecialSummonComplete()
	end
end
function cm.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function cm.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function cm.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function cm.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function cm.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function cm.tokendes(e)
	return not e:GetOwner():GetCardTarget():IsContains(e:GetHandler())
end
function cm.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x351)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil,tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,re:GetHandler(),1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
end
