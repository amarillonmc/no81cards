--以斯拉的策略 远交近攻
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011007,"Israel")
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,"tg",LOCATION_SZONE,nil,nil,rstg.target(cm.mvfilter,nil,LOCATION_MZONE),cm.mvop)
	local e3=rsef.QO(c,nil,"dis",{1,m+100},"dis,atk,des","tg",LOCATION_SZONE,rscon.excard2(rsisr.IsSet,LOCATION_MZONE),nil,rstg.target(Card.IsFaceup,"dis",0,LOCATION_MZONE),cm.disop)
end
function cm.disop(e,tp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard()
	if not c or not tc then return end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(math.ceil(atk/2))
	tc:RegisterEffect(e1)
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetValue(RESET_TURN_SET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
	if tc:IsImmuneToEffect(e) or not rsisr.exlcon(e) then return end
	rsop.SelectOC("des",true)
	rsop.SelectDestroy(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.mvfilter(c,e,tp)
	return c:IsFaceup() and rsisr.IsSet(c) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard()
	if not c or not tc or not tc:IsControler(tp) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
	local e1,e2=rsef.SV_INDESTRUCTABLE({c,tc},"effect,battle",nil,nil,rsreset.est_pend)
end