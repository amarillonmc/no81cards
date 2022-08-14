--鸦之魔女
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
function cm.initial_effect(c)
	local e1=fucg.ef.QO(c,1,nil,nil,"TG","M",nil,nil,cm.cos1,cm.tg1,cm.op1,c)
	local e2=fucg.ef.FTO(c,"SP","SP",EVENT_CHAINING,"DE","H",m,cm.con2,nil,cm.tg2,cm.op2,c)
	local e3=fucg.ef.S(c,nil,EFFECT_CANNOT_BE_EFFECT_TARGET,"SR","M",aux.tgoval,nil,nil,c)
	if not cm.glo then
		cm.glo=true
		cm.op4()
		fucg.ef.FC(c,nil,EVENT_PHASE_START+PHASE_DRAW,nil,nil,nil,nil,cm.op4,0)
	end
end
--e1
function cm.cosf1(c,e,tp,eg,ep,ev,re,r,rp)
	local ck=c:GetCode()
	for _,f in ipairs(cm[tp]) do
		if f == ck then return false end
	end
	ck=c:CheckActivateEffect(true,true,false)
	if not (c:IsType(TYPE_SPELL) and c:IsDiscardable() and ck and ck:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and ck:GetOperation()) then return false end
	local e1=fucg.ef.S(e,nil,EFFECT_CANNOT_BE_EFFECT_TARGET,"SR","M",1,nil,nil,{e,e})
	ck=ck:GetTarget() and ck:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,nil)
	e1:Reset()
	return ck
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=e:GetLabelObject()
	if chkc then return chkc~=e:GetHandler() and te and te:GetTarget() and te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return e:GetLabel()~=Duel.GetFlagEffectLabel(tp,m) and Duel.IsExistingMatchingCard(cm.cosf1,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,cm.cosf1,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	te=tc:CheckActivateEffect(true,true,false)
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	fucg.ef.Set(e,{"PRO","LAB","LABOBJ"},{te:GetProperty(),te:GetLabel(),te:GetLabelObject()})
	tc=te:GetTarget()
	local e1=fucg.ef.S(e,nil,EFFECT_CANNOT_BE_EFFECT_TARGET,"SR","M",1,nil,nil,{e,e})
	if tc then tc(e,tp,eg,ep,ev,re,r,rp,1) end
	e1:Reset()
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
	cm[tp][#cm[tp]+1] = te:GetHandler():GetCode()
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and rp==tp
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--e4
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	cm[0]={}
	cm[1]={}
end