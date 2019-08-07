--幻层驱动器 真空层
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsqd.FlipFun(c,m,"def",nil,cm.op)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"pos",nil,LOCATION_HAND,nil,c.cost,rsop.target(cm.posfilter,"pos",LOCATION_MZONE),cm.posop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.op(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa336))
	e1:SetValue(200)
	Duel.RegisterEffect(e1,tp)	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.posfilter(c)
	return c:IsCanTurnSet() and c:IsSetCard(0xa336)
end
function cm.posop(e,tp)
	rsof.SelectHint(tp,"pos")
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end