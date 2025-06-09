--神裂火炽
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(220414,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
function s.sfliter(c)
	return c.MoJin==true 
end
function s.lcheck(g,lc)
	return g:IsExists(s.sfliter,1,nil)
end
function s.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) 
	if not b1 and b2 then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
		--to zero atk/def
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		e2:SetOperation(s.zsop)
		c:RegisterEffect(e2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.atkfilterp,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
		for i=1,7 do	
			local tc=g:GetFirst()
			local atk1=c:GetAttack()
			local atk2=tc:GetAttack()
			local lp=Duel.GetLP(1-tp)
			local dam=atk1-atk2
			local p=Duel.GetTurnPlayer()
			if dam>lp then 
				Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
			else
				if c:GetFlagEffect(id)==0 then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_ATTACK)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
					c:RegisterEffect(e3)
					c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
				end
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
	end
end
function s.zsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if not tc then return end
	local lp=Duel.GetLP(1-tp)
	local atk1=e:GetHandler():GetAttack()
	local atk2=tc:GetAttack()
	local atk=math.abs(atk1-atk2)
	Duel.SetLP(1-tp,lp-atk)
end