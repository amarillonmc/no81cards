--风暴管束者
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171016)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"eq","tg",aux.dscon,cm.cost,rstg.target2(cm.fun,Card.IsFaceup,"eq",LOCATION_MZONE),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=rsef.FC(c,EVENT_BATTLED)
	e3:SetOperation(cm.tgop)
	local e4=rsds.SpExtraFun(c,m,m-10,m-6) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(cm.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		rsop.eqop(e,c,tc)
	else
		c:CancelToGrave(false)
	end
end
function cm.atkval(e,c)
	return c:GetBaseAttack()*2
end
function cm.atkcon(e)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local res= tc and tc:GetBattleTarget() and tc:GetBattleTarget():IsAttackAbove(tc:GetAttack()) and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
	if res then 
		--Duel.Hint(HINT_CARD,0,m)
		e:GetHandler():RegisterFlagEffect(m,rsreset.est_pend,0,1)		
	end
	return res
end
function cm.tgop(e,tp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

