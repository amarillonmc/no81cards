local m=53755005
local cm=_G["c"..m]
cm.name="兔子小队惬意"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(m)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetLabel(tc:GetCode())
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			return cm[0](tp,ct)
		end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local ct2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct1>0 and ct2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local num={}
		local i=1
		while i<=ct1 and i<=ct2 do
			num[i]=i
			i=i+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local ct=Duel.AnnounceNumber(tp,table.unpack(num))
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		Duel.ShuffleDeck(tp)
		ct=g:FilterCount(Card.IsSetCard,nil,0x5536)
		e:SetLabel(ct)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		local rec=ct*800
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(rec)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	else
		e:SetLabel(0)
		e:SetProperty(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()~=0 then
		local rec=e:GetLabel()*800
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,rec,REASON_EFFECT)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
	Duel.ConfirmDecktop(tp,4)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.spfilter(c,ft,e,tp,...)
	if not c:IsSetCard(0x5536) or not c:IsCode(...) then return false end
	return (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
		local le={Duel.IsPlayerAffectedByEffect(tp,m)}
		local codet={}
		for _,v in pairs(le) do table.insert(codet,v:GetLabel()) end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,ft,e,tp,table.unpack(codet)):GetFirst()
		if not tc then return end
		local sp=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local tf=tc:IsType(TYPE_SPELL+TYPE_TRAP) and not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
		local op=0
		if sp and tf then op=Duel.SelectOption(tp,1152,aux.Stringid(m,3)) elseif sp then op=0 else op=1 end
		if op==0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) else Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
