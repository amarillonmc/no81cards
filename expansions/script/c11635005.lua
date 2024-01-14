--急袭石像鬼
local m=11635005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,11635004)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,11635004),aux.NonTuner(cm.sfilter),1,1)
	c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--01
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--02
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--03
	--to extra 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
cm.SetCard_shixianggui=true
function cm.sfilter(c)
	return c.SetCard_shixianggui
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.val(c,syncard)
	local slv=c:GetSynchroLevel(syncard)
	if c:IsSynchroType(TYPE_MONSTER) and c:IsLocation(LOCATION_SZONE) and c.SetCard_shixianggui then
		slv=c:GetSynchroLevel(syncard)
	end
	return slv
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,m))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,cm.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function cm.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsCode(11635004)  and c:IsControler(tp) and (c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_MZONE)  ) then return true end 
	return c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syncard) and c:IsCode(11635004) and  c:IsFaceup() and( c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_SZONE) )
end
function cm.matfilter2(c,syncard)
	if c.SetCard_shixianggui and c:IsSynchroType(TYPE_MONSTER) and c:IsControler(tp) and (c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_MZONE)  ) and not c:IsSynchroType(TYPE_TUNER) then return true end 
	return c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syncard) and c.SetCard_shixianggui and  c:IsFaceup() and( c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_SZONE) ) and not c:IsSynchroType(TYPE_TUNER)
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return cm.CheckGroup(tsg,cm.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function cm.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.val,lv,ct,ct,syncard)
end
function cm.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c.SetCard_shixianggui and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,tp)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return cm.matfilter1(c,tp) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,tp)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=cm.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
--01
function cm.cfilter(c,tp,e)
	return c.SetCard_shixianggui and c:IsType(TYPE_MONSTER)  and (not c:IsForbidden() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp,e) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 )
	if chk==0 then return b1 or b2 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp,e) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 )
	if not b1 and not b2 then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,3)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,4)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct1=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ct>2 then ct=2 end
		if ct1>2 then ct1=2 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		if ct==0 or ct<ct1 then
			ct=ct1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.cfilter),tp,LOCATION_GRAVE,0,1,ct,nil,tp,e)
		if #g>0 then
			local tc=g:GetFirst()	  
			if tc  and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or  e:GetHandler():IsForbidden() or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then --
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			else
				while tc do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					tc:RegisterEffect(e1,true)
					tc=g:GetNext()
				end
			end
		end
	elseif sel==1 then
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc1=g1:GetFirst()
		local atkct=0
		while tc1 do
			local preatk=tc1:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc1:RegisterEffect(e2,true)
			if preatk~=0 and tc1:IsAttack(0) then atkct=atkct+1 end
			tc1=g1:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atkct*500)
		e:GetHandler():RegisterEffect(e1)
	end
end
--
function cm.cfilter2(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())   
end
function cm.thfilter2(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.SetCard_shixianggui and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--03
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA)  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.scon)
		e1:SetOperation(cm.sop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e1,tp)  
	end
end
function cm.sfilter(c,e,tp)
	return c.SetCard_shixianggui and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=g:GetNext()
		end
	end
end
--
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end