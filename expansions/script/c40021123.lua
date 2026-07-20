--纷争之幽魔 厄里斯
local s,id=GetID()
s.named_with_Darkling=1

s.COUNTER_DARKLING=0x2f1e

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.Darkling),1)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.altcon)
	e0:SetTarget(s.alttg)
	e0:SetOperation(s.altop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon1)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.discon2)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end

function s.ntfilter(c,sc,tp)
	return s.Darkling(c) and not c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(sc)
		and c:IsFaceup() and c:IsControler(tp)
end

function s.altcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(s.ntfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	return mg:IsExists(s.altcheck,1,nil,lv,tp)
end

function s.altcheck(c,lv,tp)
	local diff = lv - c:GetLevel()
	return diff>0 and Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,diff,REASON_COST)
		and Duel.GetLocationCountFromEx(tp,tp,c,c)>0
end

function s.alttg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(s.ntfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=mg:FilterSelect(tp,s.altcheck,1,1,nil,lv,tp)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.altop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local lv=c:GetLevel()
	local diff=lv-tc:GetLevel()
	Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,diff,REASON_COST)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end

function s.discon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER) or re:GetHandler():IsOnField()
end

function s.starfilter(c)
	if not c:IsFaceup() or c:IsType(TYPE_LINK) then return false end
	return (c:IsType(TYPE_XYZ) and c:GetRank()>1) or (not c:IsType(TYPE_XYZ) and c:GetLevel()>1)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.starfilter,tp,0,LOCATION_MZONE,1,nil) end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.starfilter,tp,0,LOCATION_MZONE,nil)
	local changed=false
	for tc in aux.Next(g) do
		local is_xyz = tc:IsType(TYPE_XYZ)
		local cur_val = is_xyz and tc:GetRank() or tc:GetLevel()
		local new_val = math.max(1, cur_val-2)
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(is_xyz and EFFECT_CHANGE_RANK or EFFECT_CHANGE_LEVEL)
		e1:SetValue(new_val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		changed=true
	end
	if changed and Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_EFFECT) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
			Duel.BreakEffect()
			Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,1,REASON_EFFECT)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			local sc=sg:GetFirst()
			if sc and not sc:IsDisabled() then
				Duel.HintSelection(sg)
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
			end
		end
	end
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
