--罪业之都的薪王
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171010)
function cm.initial_effect(c)
	local e1=rsds.ExtraSummonFun(c,m+6)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,rscon.phbp)
	local e3=rsef.QO(c,nil,{m,0},1,nil,nil,LOCATION_MZONE,cm.bpcon,nil,rsop.target(aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK),nil,0,LOCATION_MZONE),cm.aop)
	--damage calculate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetOperation(cm.btop)
	c:RegisterEffect(e4)
end
function cm.bpcon(e,tp)
	local ph = Duel.GetCurrentPhase()
	return ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE and Duel.GetTurnPlayer() ~= tp 
end
function cm.btop(e,tp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	cm.adop(a==c and d or a,e)
end
function cm.adop(tc,e)
	if not tc or not tc:IsRelateToBattle() then return end
	local atk=math.max(0,tc:GetBaseAttack())
	local def=math.max(0,tc:GetBaseDefense())
	--local e1,e2=rsef.SV_SET({e:GetHandler(),tc,true},"atkf,deff",{atk,def},nil,nil,"sr,ii")
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(tc:GetBaseAttack())
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BATTLE_DEFENSE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e2:SetValue(tc:GetBaseDefense())
	tc:RegisterEffect(e2,true)
end
function cm.aop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rshint.Select(1-tp,HINTMSG_SELF)
	local tg=Duel.SelectMatchingCard(1-tp,Card.IsPosition,1-tp,LOCATION_MZONE,0,1,1,nil,POS_FACEUP_ATTACK)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	if not tg:GetFirst():IsImmuneToEffect(e) then
		Duel.CalculateDamage(tg:GetFirst(),c,true)
	end
end