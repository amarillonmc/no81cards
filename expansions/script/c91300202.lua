--安洁莉娅·艾柏蓉
local m=91300202
local cm=_G["c"..m]
function cm.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.tgcost)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--attack target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.ccon)
	c:RegisterEffect(e3)
	--tohand  
	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)>=Duel.GetFlagEffect(tp,m+1) end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1,1)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:GetActivateLocation()==LOCATION_MZONE or re:GetActivateLocation()==LOCATION_SZONE)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)   
	end
end
function cm.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
cm.input ={[[+Y-6-7-O-8]],[[+Y-:-M-?,x]],[[+i-?,w-5-8]],[[+_+\-B-G+h]],[[+_,x-A+Z-D]],[[+Z+W-M-M-8]],[[+X+V--+s-@]],[[+`+[-K-K- ]]}
cm.string={}
cm.string[1]={"Celestial Gate!","这张卡回到手卡，这个回合每次场上的卡回到手卡，对方场上1张卡破坏"}
cm.string[2]={"北斗千手杀!","这个回合对方是已把效果发动过7次以上时,对方场上的怪兽全部破坏"}
cm.string[3]={"Noble Photon!","这张卡回到手卡，从手卡把这个卡名以外的1只怪兽特殊召唤。"}
cm.string[4]={"北斗罗汉击!","对方场上1只没有把效果发动过的怪兽破坏"}
cm.string[5]={"那闪耀的星光","这张卡回到手卡。这个效果发动后，这个回合对方每5次把效果发动让这个卡名的①的效果的使用次数+1。"}
cm.string[6]={"献予你的幸福之形","这张卡回到手卡，自己回复2000基本分"}
cm.string[7]={"好想拥抱你呀，梅林!","这张卡回到手卡，在自己场上把1只「梅林衍生物」（兽族·光·8星·攻/守3000）特殊召唤。"}
cm.string[8]={"北斗神拳奥义·水影心!","这张卡表侧表侧存在期间只有1次，可以把那期间由对方发动过的1个怪兽效果作为这张卡的效果发动"}
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tmp=0  Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
	for i=7,0,-1 do
		--Debug.Message(i)
		local option=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		option=1<<option
		--Debug.Message("输入了"..option)
		--Debug.Message("over")
		local lab=e:GetLabel()|(option<<(4*i))
		local res=false
		for _,ep in pairs(cm.input) do
			ep = cm.negconfilter(e,3,eg,ep,ev,re,r,rp)
			if ep&lab==lab then res=true end
			if ep==lab then tmp=ep end
		end
		if not res then break end
		e:SetLabel(lab)
	end
	e:SetLabel(tmp)
	for i,ep in pairs(cm.input) do
		ep = cm.negconfilter(e,3,eg,ep,ev,re,r,rp)
		if ep==e:GetLabel() then
			for j=1,#cm.string[i] do Debug.Message(cm.string[i][j]) end
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end --Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[2],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[3],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[4],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[6],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[7],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[1],ev,re,r,rp) then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(cm.damcon1)
		e1:SetOperation(cm.damop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[2],ev,re,r,rp) then
		local ecount = Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)
		if ecount >= 7 then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[3],ev,re,r,rp) then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[4],ev,re,r,rp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[5],ev,re,r,rp) then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(m+5)~=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(cm.ctcon)
		e1:SetOperation(cm.ctop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(m+5,RESET_PHASE+PHASE_END,0,1,1)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[6],ev,re,r,rp) then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		Duel.Recover(tp,2000,REASON_EFFECT)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[7],ev,re,r,rp) then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,91300203,0,TYPES_TOKEN_MONSTER,3000,3000,8,RACE_BEAST,ATTRIBUTE_LIGHT))then return end
		local token=Duel.CreateToken(tp,91300203)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[8],ev,re,r,rp) then
		local tc=e:GetHandler()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.condition)
		e1:SetOperation(cm.operation)
		tc:RegisterEffect(e1)
	end
end
function cm.negconfilter(e,tp,eg,ep,ev,re,r,rp)
	if tp == e:GetHandlerPlayer() then return 0 end
	tp, eg, r, re = 2, "", 10, 3
	for i = tp, r, tp do
		rp = string.format("%02d", ep:byte(i - 1) - re * r - tp)
		rp = string.format("%X", rp .. string.format("%02d", ep:byte(i) - re * r - tp))
		rp = string.char(tonumber(rp:sub(1, tp))) .. rp:sub(re, re)
		eg = eg .. string.format("%02d", tonumber(rp, r + tp * re))
	end
	return tonumber(eg)
end
function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.cfilter2(c,e,tp)
	return not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cfilter3(c)
	return c:GetFlagEffect(m)==0
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+2)==0 then 
		Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1,1)
	else
		local label=Duel.GetFlagEffectLabel(tp,m+2)
		Duel.SetFlagEffectLabel(tp,m+2,label+1)
	end
	if Duel.GetFlagEffectLabel(tp,m+2)>3 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,1)
		Duel.SetFlagEffectLabel(tp,m+2,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()==1-tp and e:GetHandler():GetFlagEffect(m+4)==0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=re:GetOperation()
	if not op then return end
	Duel.Hint(HINT_CARD,tp,re:GetHandler():GetOriginalCode())
	if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		c:RegisterFlagEffect(m+4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,5))
		e:GetHandler():SetHint(CHINT_CARD,re:GetHandler():GetOriginalCode())
		local ce=Effect.CreateEffect(c)
		local desc=re:GetDescription()
		local con=re:GetCondition()
		local cost=re:GetCost()
		local target=re:GetTarget()
		local operation=re:GetOperation()
		local code=re:GetCode()
		local pro1,pro2=re:GetProperty()
		ce:SetDescription(desc)
		ce:SetType(re:GetType())
		if con then 
			ce:SetCondition(con)
		end
		if cost then
			ce:SetCost(cost)
		end
		if target then
			ce:SetTarget(target)
		end
		if operation then
			ce:SetOperation(operation)
		end
		ce:SetReset(RESET_EVENT+RESETS_STANDARD)
		ce:SetRange(LOCATION_SZONE)
		if code then
			ce:SetCode(code)
		else
			ce:SetCode(EVENT_FREE_CHAIN)
		end
		if pro1 and pro2 then
			ce:SetProperty(pro1,pro2)
		end
		ce:SetCountLimit(1)
		c:RegisterEffect(ce,true)
	end
end