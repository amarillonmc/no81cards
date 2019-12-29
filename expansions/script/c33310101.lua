--恶魔的提线魔术
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33310101)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,0x1},"tg",nil,LOCATION_SZONE,nil,nil,rsop.target2(cm.fun,cm.copyfilter,"tg",LOCATION_DECK),cm.copyop)
	local e3=rsef.QO(c,nil,{m,1},{1,0x1},"dis",nil,LOCATION_SZONE,nil,nil,rsop.target(aux.disfilter1,"dis",0,LOCATION_ONFIELD),cm.disop)
	local e4=rsef.QO(c,nil,{m,2},{1,0x1},nil,nil,LOCATION_SZONE,cm.skipcon,nil,nil,cm.skipop)
end
function cm.copyfilter(c,e,tp)
	if not c:IsCode(33310102) or not c:IsAbleToGrave() then return false end   
	return c:CheckActivateEffect(false,true,false)~=nil
end
function cm.copyop(e,tp)
	rsof.SelectHint(tp,"tg")
	local tc=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	local te=tc:GetActivateEffect()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"dis")
	local tc=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(rsgf.Mix2(tc))
	local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est)
	Duel.AdjustInstantly(c)
	if tc:IsDisabled() and tc:IsType(TYPE_MONSTER) then
		local e3=rsef.SV_INDESTRUCTABLE({c,tc},"battle",nil,nil,rsreset.est)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetReset(rsreset.est)
		e4:SetCode(EFFECT_MUST_ATTACK)
		tc:RegisterEffect(e4)
	end
end
function cm.skipcon(e,tp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and rscon.excard2(rscf.CheckSetCard,LOCATION_MZONE,0,1,nil,"Cochrot")
end
function cm.skipop(e,tp)
	local p=Duel.GetTurnPlayer()
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1)
	Duel.RegisterEffect(e2,p)
end