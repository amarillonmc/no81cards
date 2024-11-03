--幻想时间 可怖之书
local m=21192020
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syscon(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetTarget(cm.systg(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetOperation(aux.SynOperation(cm.x,aux.NonTuner(cm.x),1,6))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.x(c)
	return c:IsSetCard(setcard)
end
function cm.q(c,sc)
	return c:IsCanBeSynchroMaterial(sc) and c:IsFaceup() and c:IsSetCard(setcard)
end
function cm.syscon(f1,f2,minc,maxc)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end 
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function cm.systg(f1,f2,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				local g=nil 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.w(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(setcard) and c:IsType(1) and Duel.GetLocationCount(tp,8)>0 and not c:IsForbidden() and Duel.IsExistingMatchingCard(cm.e,tp,0x30,0,1,c,e)
end
function cm.e(c,e)
	return c:IsAbleToDeck() and c:IsFaceupEx() and c:IsSetCard(setcard) and c:IsType(1) and c:IsCanBeEffectTarget(e)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.w,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,cm.w,tp,0x30,0,1,1,nil,e,tp)
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,cm.e,tp,0x30,0,1,1,g1,e)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,tp,0x30)
end
function cm.r(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(setcard) and c:IsType(1) and Duel.GetLocationCount(tp,8)>0 and not c:IsForbidden()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g<=0 then return end
	Duel.Hint(3,tp,HINTMSG_TOFIELD)
	local sg=g:Filter(cm.r,nil)
	if #sg>0 then
	local tc=sg:Select(tp,1,1,nil):GetFirst()
		if not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,tp,8,POS_FACEUP,true) then
		g:RemoveCard(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		end
	end
	if #g>0 then 
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end

function cm.syn(c,tp,g)
	return c:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,c)
end
function cm.syncheck(g,tp,exc)
	return Duel.IsExistingMatchingCard(cm.syn,tp,LOCATION_EXTRA,0,1,exc,tp,g)
end
function cm.spcheck(c,tp,rc,mg,opchk)
	return Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and (opchk or mg:CheckSubGroup(cm.syncheck,2,#mg,tp,c))
end
function cm.sc(c,e,tp,rc,chkrel,chknotrel,tgchk,opchk)
	if not (rc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0) then return end
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) or not c:IsSetCard(setcard) or not c:IsType(TYPE_SYNCHRO) then return end
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if #mg2>0 then mg:Merge(mg2) end
	end
	mg:AddCard(c)
	if tgchk then
		return cm.spcheck(c,tp,nil,mg,opchk)
	else
		return (chkrel and cm.spcheck(c,tp,rc,mg-rc)) or (chknotrel and cm.spcheck(c,tp,nil,mg))
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsCostChecked() then return true end
		local c=e:GetHandler()
		local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
			and aux.ExtraDeckSummonCountLimit[tp]
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and (not ect1 or ect1>1) and (not ect2 or ect2>1)
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and Duel.IsExistingMatchingCard(cm.sc,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,nil,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function cm.t(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(setcard)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2,true)
	local g=Duel.GetMatchingGroup(cm.t,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,tc,nil)
		end
	end
end