--鸦之魔女
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
function cm.initial_effect(c)
	local e1=fucg.ef.QO(c,0,nil,nil,"TG","H",nil,cm.con1,cm.cos1,cm.tg1,cm.op1,c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.cosf1(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(true,true,false)
	if not (c:IsType(TYPE_SPELL) and c:IsDiscardable() and te and te:IsHasProperty(16) and te:GetOperation()) then return false end
	Debug.Message(te:GetCode())
	return te:GetTarget() and te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=e:GetLabelObject()
	if chkc then return te and te:GetTarget() and te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return e:GetLabel()~=Duel.GetFlagEffectLabel(tp,m) and fucg.gf.GGF(tp,"H",0,cm.cosf1,{{e,tp,eg,ep,ev,re,r,rp}},nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,cm.cosf1,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	te=tc:CheckActivateEffect(true,true,false)
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	fucg.ef.Set(e,{"PRO","LAB","LABOBJ"},{te:GetProperty(),te:GetLabel(),te:GetLabelObject()})
	tc=te:GetTarget()
	if tc then tc(e,tp,eg,ep,ev,re,r,rp,1) end
	fucg.ef.Set(te,{"LAB","LABOBJ"},{e:GetLabel(),e:GetLabelObject()})
	fucg.ef.Set(e,"LABOBJ",te)
	Duel.ClearOperationInfo(0)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1,100)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	fucg.ef.Set(e,{"LAB","LABOBJ"},{te:GetLabel(),te:GetLabelObject()})
	if te:GetOperation() then te:GetOperation()(e,tp,eg,ep,ev,re,r,rp) end
	fucg.ef.Set(te,{"LAB","LABOBJ"},{e:GetLabel(),e:GetLabelObject()})
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	local fid=e:GetHandler():GetFieldID()
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	fucg.ef.FC(e,1,EVENT_PHASE+PHASE_BATTLE,EFFECT_FLAG_IGNORE_IMMUNE,nil,1,cm.op2con,cm.op2op,tp,nil,fid,e:GetHandler())
	Duel.SpecialSummonComplete()
end
function cm.op2con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.op2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end