--第三行星的奇迹
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000083)
function cm.initial_effect(c)
	local e1=rsef.FC(c,EVENT_PHASE_START+PHASE_DRAW,nil,nil,nil,LOCATION_DECK,cm.thcon,cm.thop)
	local e2=rsef.ACT(c,nil,nil,nil,"rec","cd,cn,tg",nil,nil,rstg.target(cm.cfilter,nil,LOCATION_MZONE,LOCATION_MZONE),cm.act)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==0 and c:GetBaseDefense()==0
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard()
	if not tc then return end
	Duel.Recover(tc:GetControler(),1000,REASON_EFFECT)
	local e1=rsef.FC({c,tp},EVENT_PHASE+PHASE_END,nil,nil,nil,nil,cm.damcon,cm.damop,{rsreset.pend,2})
	e1:SetLabelObject(tc)
	e1:SetLabel(c:GetFieldID())
	e1:SetValue(Duel.GetTurnCount())
	tc:RegisterFlagEffect(m,rsreset.est,0,2,c:GetFieldID())
end
function cm.damcon(e,tp)
	return Duel.GetTurnCount()~=e:GetValue() and e:GetLabelObject():GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.damop(e,tp)
	rshint.Card(m)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
function cm.thcon(e,tp)
	return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(rscf.fufilter(Card.IsOriginalCodeRule,25010012),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanSendtoHand(tp,e:GetHandler())
end
function cm.thop(e,tp)
	local c=e:GetHandler()
	if rsop.SelectYesNo(tp,{m,0},m) and aux.TRUE(Duel.RegisterFlagEffect(tp,m,0,0,1)) and Duel.SendtoHand(c,nil,REASON_RULE)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
end