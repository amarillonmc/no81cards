--人理嘘饰 提丰·厄斐墨洛斯
local m=11513094
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddMaterialCodeList(c,11513092,11513093)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,11513092,11513093),c11513094.matfilter,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--toh
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513094,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c11513094.tttg)
	e1:SetOperation(c11513094.ttop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11513094,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c11513094.efcon)
	e4:SetTarget(c11513094.eftg)
	e4:SetOperation(c11513094.efop)
	c:RegisterEffect(e4)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c11513094.matcon)
	e5:SetOperation(c11513094.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c11513094.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--fusion
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(11513094,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCountLimit(1,11513094)
	e7:SetCondition(c11513094.fscon1)
	e7:SetTarget(c11513094.fstg1)
	e7:SetOperation(c11513094.fsop1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCountLimit(1,11514094)
	e8:SetCondition(c11513094.fscon2)
	e8:SetTarget(c11513094.fstg2)
	e8:SetOperation(c11513094.fsop2)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCountLimit(1,11515094)
	e9:SetCondition(c11513094.fscon3)
	e9:SetTarget(c11513094.fstg3)
	e9:SetOperation(c11513094.fsop3)
	c:RegisterEffect(e9)
	--mo
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_LEAVE_FIELD_P)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetOperation(c11513094.regop)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_TO_DECK)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(c11513094.mocon)
	e11:SetTarget(c11513094.motg)
	e11:SetOperation(c11513094.moop)
	e11:SetLabelObject(e10)
	c:RegisterEffect(e11)
end
function c11513094.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON)
end
function c11513094.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c11513094.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11513095,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c11513094.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetCount()-1
	e:GetLabelObject():SetLabel(ct)
end

function c11513094.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c11513094.ttop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if #rc>0 then Duel.Remove(rc,POS_FACEUP,REASON_EFFECT) end
	Duel.Draw(tp,1,REASON_EFFECT)
	if c:IsRelateToEffect(e) then Duel.SendtoGrave(c,REASON_EFFECT) end
end
function c11513094.effilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or not c:IsType(TYPE_MONSTER))
end
function c11513094.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(11513095) and e:GetHandler():GetFlagEffectLabel(11513095)>0
end
function c11513094.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11513094.effilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(11513094)<c:GetFlagEffectLabel(11513095) end
	c:RegisterFlagEffect(11513094,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c11513094.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c11513094.effilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		--mill
		local e99=Effect.CreateEffect(c)
		e99:SetDescription(aux.Stringid(11513094,2))
		e99:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TOGRAVE)
		e99:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
		e99:SetCode(EVENT_CHAINING)
		e99:SetRange(LOCATION_MZONE)
		e99:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e99:SetCondition(c11513094.effcon)
		e99:SetTarget(c11513094.efftg)
		e99:SetOperation(c11513094.effop)
		tc:RegisterEffect(e99)
	end
end
function c11513094.effcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_HAND or loc==LOCATION_GRAVE or loc==LOCATION_REMOVED
end
function c11513094.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if chk==0 then e:SetLabel(loc) return true end
	if loc==LOCATION_REMOVED then
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	end
	if loc==LOCATION_HAND then
	Duel.SetOperationInfo(0,CATEGORY_DRAW,e:GetHandler(),1,0,0)
	end
	if loc==LOCATION_GRAVE then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	end
end
function c11513094.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=e:GetLabel()
	if c:IsRelateToEffect(e) and loc==0x2 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) and loc==0x10 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) and loc==0x20 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

function c11513094.fscon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_TOHAND)) and c:IsFaceup()
end
function c11513094.fscon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsHasCategory(CATEGORY_TOGRAVE) and c:IsFaceup()
end
function c11513094.fscon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsHasCategory(CATEGORY_REMOVE) and c:IsFaceup()
end
function c11513094.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c11513094.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c11513094.filter2(c,e,tp,m,f,chkf,tc)
	return tc==c and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11513094.fstg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c11513094.filter0,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11513094.fstg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c11513094.filter0,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11513094.fstg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c11513094.filter0,tp,LOCATION_REMOVED+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11513094.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11513094.fsop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c11513094.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c11513094.fsop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c11513094.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c11513094.fsop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c11513094.filter1,tp,LOCATION_REMOVED+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11513094.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c11513094.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(11513095) then
	local ct=c:GetFlagEffectLabel(11513095)
	e:SetLabel(ct)
	end
end
function c11513094.mocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	return c:IsLocation(LOCATION_EXTRA) and ct>0 -- and c:IsFaceup()
end
function c11513094.motg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) and (Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 or Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)) end
	if ct>2 then
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND)
	end
end
function c11513094.moop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	if g3:GetCount()>0 and ct>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(11513094,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g3:RandomSelect(tp,1)
		Duel.HintSelection(sg1)
		ct=ct-1
	end
	if g1:GetCount()>0 and ct>0 and ((sg1:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(11513094,5))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local sg2=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		ct=ct-1
	end
	if g2:GetCount()>0 and ct>0 and ((sg1:GetCount()==0 and sg2:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(11513094,6))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g2:RandomSelect(tp,1)

	end
	if sg1:GetCount()>0 then Duel.SendtoGrave(sg1,REASON_EFFECT) end
	if sg2:GetCount()>0 then Duel.SendtoHand(sg2,nil,REASON_EFFECT) end
	if sg3:GetCount()>0 then Duel.Remove(sg3,POS_FACEUP,REASON_EFFECT) end
end