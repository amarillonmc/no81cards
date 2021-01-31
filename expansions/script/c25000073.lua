--超机械兽 百万巴萨库
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000073)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	rscf.SetSpecialSummonProduce(c,LOCATION_HAND+LOCATION_GRAVE,cm.spcon,cm.spop)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"an","de,dsp",nil,nil,cm.antg,cm.anop)
	local e2=rsef.SV_CANNOT_BE_TARGET(c,"effect")
	local e3=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e4,e5=rsef.SV_LIMIT(c,"ress,ressns")
	local e6=rsef.QO(c,nil,{m,1},1,"eq",nil,LOCATION_MZONE,rscon.phmp,nil,rsop.target(cm.eqfilter,"eq",0,LOCATION_MZONE),cm.eqop)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e7:SetOperation(cm.btop)
	c:RegisterEffect(e7)
end
function cm.spcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,3,c)
end
function cm.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function cm.spop(e,tp)
	rsop.SelectToGrave(tp,cm.cfilter,tp,LOCATION_MZONE,0,3,3,nil,{REASON_COST })
end
function cm.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.anop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0,0x7f)
	e1:SetTarget(cm.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.eqfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	rsop.SelectSolve(HINTMSG_EQUIP,tp,cm.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,cm.solvefun,e,tp)
end
function cm.solvefun(g,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	rsop.eqop(e,tc,c)
end
function cm.btop(e,tp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not d then return end
	cm.adop(a==c and d or a,e)
end
function cm.adop(tc,e)
	if not tc or not tc:IsRelateToBattle() then return end
	local atk=math.max(0,tc:GetBaseAttack()/2)
	local def=math.max(0,tc:GetBaseDefense()/2)
	--local e1,e2=rsef.SV_SET({e:GetHandler(),tc,true},"atkf,deff",{atk,def},nil,nil,"sr,ii")
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(atk)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BATTLE_DEFENSE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e2:SetValue(def)
	tc:RegisterEffect(e2,true)
end