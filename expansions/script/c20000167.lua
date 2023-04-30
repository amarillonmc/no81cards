--一念万物
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.B_A(c,nil,"SP",nil,"TG",m,nil,cm.cos1,cm.tg1,cm.op1,c)
	local e2=fuef.I(c,nil,nil,nil,"G",m,nil,cm.cos2,nil,cm.op2,c)
	Duel.AddCustomActivityCounter(m+1,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
--e1
function cm.cosf1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m+1,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=fuef.F(e,nil,EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH,nil,{1,0},nil,nil,nil,cm.cosf1,nil,tp,RESET_PHASE+PHASE_END)
end
function cm.tgf1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e)
		and c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0xcfd1):IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,true,false,POS_FACEUP)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgf1(chkc,e,tp) end
	if chk==0 then return fugf.GetFilter(tp,"M",cm.tgf1,{e,tp},nil,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local c=fugf.SelectTg(tp,"M",cm.tgf1,{e,tp},nil,1):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0xcfd1):Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,true,false,POS_FACEUP)
	ft=ft<#g and ft or #g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,ft,ft,nil)
	if #g==0 then return end
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2=fuef.S(e,0,EFFECT_CANNOT_DIRECT_ATTACK,"HINT",nil,nil,nil,nil,nil,tc,RESET_EVENT+RESETS_STANDARD)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
	Duel.SpecialSummonComplete()
	g:AddCard(c)
	g:KeepAlive()
	local e1=fuef.FC(e,nil,EVENT_PHASE+PHASE_END,EFFECT_FLAG_IGNORE_IMMUNE,nil,1,cm.op1con1,cm.op1op1,tp,nil,fid,g)
end
function cm.op1conf1(c,fid,chk)
	if chk then return not c:GetFlagEffectLabel(m) end
	return c:GetFlagEffectLabel(m)==fid
end
function cm.op1con1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.op1conf1,1,nil,e:GetLabel()) or not g:IsExists(cm.op1conf1,1,nil,e:GetLabel(),1) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.op1op1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local c=g:Filter(cm.op1conf1,nil,e:GetLabel(),1):GetFirst()
	g=g:Filter(cm.op1conf1,nil,e:GetLabel())
	for tc in aux.Next(g) do
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
	end
	Duel.Overlay(c,g)
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.cos1(e,tp,eg,ep,ev,re,r,rp,0) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end