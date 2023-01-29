--魔王剑-嗫告篇帙
local m=33400342
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	--confirm 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.operation2)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m+10000)
	e5:SetCost(cm.cost2)
	e5:SetTarget(cm.tg)
	e5:SetOperation(cm.tgop2)
	c:RegisterEffect(e5)
 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
		and Duel.GetFlagEffect(tp,m)==0 
end
function cm.tgfilter(c)
	return c:IsSetCard(0x6342) and c:IsAbleToGrave()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		local ec=re:GetHandler()
		local g=Group.CreateGroup()			   
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.cgefilter(tp))
		Duel.SendtoDeck(ec,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)	
	end
end
function cm.cgefilter(tp)
	 Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end

function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0 end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm1>5 then cm1=5 end
		if cm2>5 then cm2=5 end
		local g=Duel.GetDecktopGroup(tp,cm1)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm1)
		local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2)
end

function cm.refilter(c,tp,re)
	local flag=true
	local value={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	if #value>0 then
		for k,re in ipairs(value) do
			local val=re:GetTarget()
			if val and val(re,c,tp) then
				flag=false
			end
		end 
	end
	return  c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP)  and flag)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0  then  
		local ck=0 
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
	 if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and result
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.cfilter(c)
	return c:IsSetCard(0x6342) and c:IsAbleToGraveAsCost()
end
function cm.thfilter2(c,tp)
	return c:IsCode(33400200) 
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local key=1
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)  
			key=0
			 if Duel.IsExistingMatchingCard(cm.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,6)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
				local g3=Duel.SelectMatchingCard(1-tp,cm.thfilter2,1-tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,1-tp)
				local tc=g3:GetFirst()
				if tc then
					local b1=tc:IsAbleToHand()
					local b2=tc:GetActivateEffect():IsActivatable(1-tp)
					if b1 and (not b2 or Duel.SelectOption(1-tp,1190,1150)==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(tp,tc)
					else
						Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
						local te=tc:GetActivateEffect()
						local tep=tc:GetControler()
						local cost=te:GetCost()
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					end
					Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
				end		 
			end
		end
	if key==1 then 
		local tc2=e:GetHandler()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
		 Duel.ConfirmDecktop(1-tp,1)
		local g1=Duel.GetDecktopGroup(1-tp,1)
		local tc=g1:GetFirst()
		local token=Duel.CreateToken(tp,ac)
		local t1=bit.band(token:GetType(),0x7)
		local t2=bit.band(tc:GetType(),0x7)
		if t1==t2  then 
			 Duel.Damage(1-tp,1000,REASON_EFFECT) 
			 if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g4=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
				local ck=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
				if ck==0 then Duel.SendtoDeck(g4,nil,0,REASON_EFFECT) end 
				if ck==1 then Duel.SendtoDeck(g4,nil,1,REASON_EFFECT) end		  
			 end
		end
		if tc:IsCode(ac) then  
		   Duel.Damage(1-tp,1000,REASON_EFFECT) 
		   if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
				local g5=Duel.GetDecktopGroup(tp,5)
				Duel.ConfirmCards(tp,g5)			
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g5:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.SortDecktop(tp,tp,4)   
		   end
	end
end 

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return m-10 and c:GetOriginalCode()==m
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(m-10)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(m-10,0,0)
end
