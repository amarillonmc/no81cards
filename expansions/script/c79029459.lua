--深海猎人·特种干员-歌蕾蒂娅
function c79029459.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79029459.ttcon)
	e1:SetOperation(c79029459.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c79029459.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)	
	--anti summon and remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029459)
	e1:SetCondition(c79029459.rmcon)
	e1:SetTarget(c79029459.rmtg)
	e1:SetOperation(c79029459.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3) 
	--swap
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,09029459)
	e5:SetTarget(c79029459.swtg)
	e5:SetOperation(c79029459.swop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_MOVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c79029459.recon)
	e6:SetOperation(c79029459.reop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_MOVE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c79029459.regcon)
	e7:SetOperation(c79029459.regop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c79029459.recon2)
	e8:SetOperation(c79029459.reop2)
	c:RegisterEffect(e8)
	if not c79029459.global_check then
		c79029459.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(c79029459.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(c79029459.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function c79029459.checkop(e,tp,eg,ep,ev,re,r,rp)
	c79029459.chain_solving=true
end
function c79029459.reset(e,tp,eg,ep,ev,re,r,rp)
	c79029459.chain_solving=false
end
function c79029459.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c79029459.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	Debug.Message("这些战斗的强度很低，请准许我将这当作是对干员的狩猎训练来处理。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029459,1))
end
function c79029459.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c79029459.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c79029459.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(aux.TRUE,nil,e:GetHandler())
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c79029459.rmop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("小心了，海流会追索脆弱的生命。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029459,3))
	Duel.NegateSummon(eg)
	local g=eg:Clone()
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c79029459.swtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,2,nil) end
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,2,2,nil) 
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SetChainLimit(c79029459.chlimit)
end
function c79029459.chlimit(e,ep,tp)
	return tp==ep
end
function c79029459.swop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("只需等上小半秒，这把槊就能滑入你心间。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029459,4))
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.SwapSequence(tc1,tc2)
		local tc=g:GetFirst()
		while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(79029459,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c79029459.ckfil(c)
	return c:IsOnField() and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029459.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029459.ckfil,1,nil)
end
function c79029459.reop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("呵......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029459,2))
	Duel.Hint(HINT_CARD,0,79029459)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c79029459.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029459.ckfil,1,nil) and c79029459.chain_solving
end
function c79029459.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(79029459,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function c79029459.recon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029459)>0
end
function c79029459.reop2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("呵......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029459,2))
	e:GetHandler():ResetFlagEffect(79029459)
	Duel.Hint(HINT_CARD,0,79029459)
	Duel.Recover(tp,1000,REASON_EFFECT)
end






