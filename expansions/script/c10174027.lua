--流星羽
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174027
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x31)
	local e1=rsef.ACT_EQUIP(c)
	local e2=rsef.FTF(c,EVENT_EQUIP,{m,0},nil,"atk,ct",nil,LOCATION_SZONE,cm.con,nil,cm.tg,cm.op)
	local e3=rsef.FTO(c,EVENT_DAMAGE_STEP_END,{m,1},nil,nil,nil,LOCATION_SZONE,cm.acon,cm.acost,cm.tg,cm.aop)
	local e4=rsef.I(c,{m,2},{1,m},"eq","tg",LOCATION_GRAVE,cm.eqcon,nil,rstg.target({aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK),"eq",LOCATION_MZONE }),cm.eqop)
end
function cm.eqcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not c or not tc then return false end
	if not rsop.eqop(e,c,tc) then return end
	local e1=rsef.SV_REDIRECT(c,"leave",LOCATION_REMOVED,nil,rsreset.ered,EFFECT_FLAG_CANNOT_DISABLE)
end
function cm.acon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	return ac==e:GetHandler():GetEquipTarget() and ac:IsControler(tp) and ac:IsChainAttackable(0,true)
end
function cm.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x31,1,REASON_COST) end
	c:RemoveCounter(tp,0x31,1,REASON_COST)
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local ac=rscf.GetTargetCard(Card.IsFaceup)
	if not ac or not ac:IsRelateToBattle() or c:GetEquipTarget()~=ac then return end
	Duel.ChainAttack()
	local e1=rsef.SV_LIMIT({c,ac},"datk",nil,nil,rsreset.est+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,e:GetHandler())
end
function cm.cfilter(c,tp,rc)
	return c:GetEquipTarget():IsControler(tp) and c==rc
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=e:GetHandler():GetEquipTarget()
	Duel.SetTargetCard(ec)
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local atk=tc:GetAttack()/2
	local e1=rsef.SV_SET({c,tc},"atkf",atk,nil,rsreset.est)
	if c:IsFaceup() then
		c:AddCounter(0x31,4)
	end
end