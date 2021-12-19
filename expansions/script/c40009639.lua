--伐楼利拿·巴瑞恩特
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009639)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.SV_Card(c,"atk+",cm.val,"sr",LOCATION_MZONE)
	local e2 = rsef.FTO(c,EVENT_PHASE+PHASE_BATTLE,{m,0},{1,m,"d"},
		nil,nil,LOCATION_MZONE,cm.skcon,nil,nil,cm.skop)
	rsfwh.ExtraEffect(e2)
end
function cm.rsfwh_ex_ritual(c)
	return  (c:IsSetCard(0x6f1b) and c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF )
end
function cm.val(e,c)
	return c:GetOverlayCount() * 1000
end 
function cm.skcon(e,tp)
	return Duel.GetTurnPlayer() == tp and e:GetHandler():GetFlagEffect(m) > 0
end
function cm.skop(e,tp)
	local c = e:GetHandler()
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end