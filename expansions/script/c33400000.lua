--星眼
XY=XY or {}
XY.loaded_metatable_list={}
------
function XY.REZS(c)
if c:IsSetCard(0x5349) and not (c:GetCode()==33403501) then 
		--set
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge2:SetCode(EVENT_PHASE+PHASE_END)
	ge2:SetRange(LOCATION_GRAVE)
	ge2:SetCondition(XY.recon)
	ge2:SetCost(XY.recost)
	ge2:SetTarget(XY.resettg)
	ge2:SetOperation(XY.resetop)
	c:RegisterEffect(ge2)
else 
 --draw
	local ge3=Effect.CreateEffect(c)
	ge3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ge3:SetRange(LOCATION_GRAVE)
	ge3:SetCode(EVENT_PHASE+PHASE_END)
	ge3:SetCondition(XY.recon)
	ge3:SetCost(XY.recost)
	ge3:SetTarget(XY.drtg)
	ge3:SetOperation(XY.drop)
	c:RegisterEffect(ge3)
end 
if c:IsSetCard(0x5349) and  c:IsType(TYPE_TRAP) then 
  --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(XY.handcon)
	c:RegisterEffect(e3)
end
	if not XY.zs then
		XY.zs=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)   
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(XY.zsop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function XY.zsfilter1(c,rp)
	return   Duel.GetFlagEffect(rp,33443500)==0  
end
function XY.zsckfilter1(c,rp,re)
	return c:GetSummonPlayer()==rp and   not c:IsCode(33403500) and (re and not re:GetHandler():IsSetCard(0x5349))
end
function XY.zsop1(e,tp,eg,ep,ev,re,r,rp)
	if  eg:IsExists(XY.zsckfilter1,1,nil,rp,re)  then   
	Duel.RegisterFlagEffect(rp,33443500,RESET_PHASE+PHASE_END,0,1)
	end 
end

function XY.handcon(e)
	return Duel.IsExistingMatchingCard(XY.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
function XY.hdfilter(c)
	return c:IsFaceup() and   c:IsCode(33403500) 
end

function XY.recost(e,tp,eg,ep,ev,re,r,rp,chk)  
if chk==0 then return   aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)  end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(XY.REsplimit)
	Duel.RegisterEffect(e1,tp) 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function XY.REsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349) and  not c:IsCode(33403500)
end

function XY.recon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,33413502)<Duel.GetTurnCount() and Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and Duel.GetFlagEffect(tp,33443500)==0   
end
function XY.REstfilter(c,m)
	return c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(m)
end
function XY.resettg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+20000)==0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(XY.REstfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
end
function XY.resetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,XY.REstfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

function XY.drfilter(c,e)
	return c:IsSetCard(0x5349) and c:IsAbleToDeck() 
end
function XY.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)  and g:GetClassCount(Card.GetCode)>=5  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,c:GetCode()+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33413502,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
end
function XY.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(XY.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	if g:GetClassCount(Card.GetCode)>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
	end
end
------mayuri
function XY.mayuri(c)
local cd=c:GetCode()
	if not c:IsLevel(12) then
--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(XY.mayuribfcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e0:SetOperation(XY.mayuriregop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(XY.mayuriregcon)
	e1:SetOperation(XY.mayuriregop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(XY.mayuriregcon)
	e2:SetOperation(XY.mayuriregop2)
	c:RegisterEffect(e2)
	end
	if c:IsLevel(4) then 
	  --spsummon
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e5:SetCode(EVENT_SUMMON_SUCCESS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetRange(LOCATION_HAND)
		e5:SetCountLimit(1,cd)
		e5:SetCondition(XY.mayurispcon)   
		e5:SetTarget(XY.mayurisptg)
		e5:SetOperation(XY.mayurispop)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e6)
	end
	if c:IsLevel(8) then 
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,cd)
	e5:SetCondition(XY.mayurispcon2)
	e5:SetTarget(XY.mayurisptg2)
	e5:SetOperation(XY.mayurispop2)
	c:RegisterEffect(e5)
	end
end
--inside
function XY.mayuribfcon(e)
	return e:GetHandler():GetFlagEffect(e:GetHandler():GetCode())==0
end
function XY.mayuriregop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33401601,0))
end
function XY.mayuriregcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler()==e:GetHandler()
end
function XY.mayuriregop1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33401601,0))
end
function XY.mayuriregop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local fs=c:GetFlagEffect(c:GetCode())
	c:ResetFlagEffect(c:GetCode())
	for i=1,fs-1 do
	c:RegisterFlagEffect(c:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(33401601,0))
	end
end
--sp
function XY.mayuricfilter(c,at)
	return c:IsFaceup() and( c:IsSetCard(0x6344) or c:GetAttribute()&at~=0)
end
function XY.mayurispcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(XY.mayuricfilter,1,nil,c:GetAttribute()) 
end
function XY.mayurisptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function XY.mayurispop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or   not c:IsRelateToEffect(e)  then return end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
end
--leave sp
function XY.mayurispcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and  c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function XY.mayurispfilter2(c,e,tp,at)
	return  c:IsSetCard(0x341) and c:IsLevel(4) and c:IsAttribute(at) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function XY.mayurisptg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function XY.mayurispop2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,XY.mayurispfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetAttribute())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
------magane
function XY.magane(c)
local cd=c:GetCode()
if c:IsType(TYPE_QUICKPLAY) then 
   --activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(XY.maganehandcon)
	c:RegisterEffect(e0)
	--TRICK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL) 
	e2:SetCost(XY.maganechcost)
	e2:SetTarget(XY.maganetg)
	e2:SetOperation(XY.maganechop)
	e2:SetLabel(cd)
	c:RegisterEffect(e2)
end
   
end
function XY.maganehdfilter(c)
	return c:IsFaceup() and c:IsCode(33403520)
end
function XY.maganehandcon(e)
	return Duel.IsExistingMatchingCard(XY.maganehdfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

function XY.maganecostfilter1(c)
	return  c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function XY.maganechcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(XY.maganecostfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,XY.maganecostfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD) then 
		if  Duel.Remove(tc,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)>0 then 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_END)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetReset(RESET_EVENT+PHASE_END)
				e1:SetOperation(XY.maganeretop)
				Duel.RegisterEffect(e1,tp)
				e:SetLabelObject(tc)
		 end
	else
		Duel.Remove(tc,POS_FACEDOWN,REASON_COST)
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(XY.maganeretcon2)
		e1:SetOperation(XY.maganeretop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(33403520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		e:SetLabelObject(tc)
	end
end

function  XY.maganeretop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_FIELD) and tc:IsPreviousLocation(LOCATION_FZONE) then  
		if  tc:IsPreviousPosition(POS_FACEUP) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
		end 
	elseif  tc:IsType(TYPE_PENDULUM) and tc:IsPreviousLocation(LOCATION_PZONE) then
		if  tc:IsPreviousPosition(POS_FACEUP) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEDOWN,true)
		end
	else
		 Duel.ReturnToField(tc)
	end
end
function  XY.maganeretcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33403520)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function  XY.maganeretop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end

function XY.maganethfilter1(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520))  and c:IsAbleToHand()
end
function XY.maganethfilter4(c)
	return  c:IsAbleToGrave()
end
function XY.maganetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local codes={}
   local ck=0
   if  Duel.GetFlagEffect(tp,33403521)==0 and Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then   
		table.insert(codes,33403521)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403522)==0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
		 table.insert(codes,33403522)
		 ck=1
   end
   if Duel.GetFlagEffect(tp,33403523)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		table.insert(codes,33403523)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403524)==0 and Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) then
		table.insert(codes,33403524)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403525)==0 and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)  then
		table.insert(codes,33403525)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403526)==0 and Duel.IsPlayerCanDraw(tp,2)  then
		table.insert(codes,33403526)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403527)==0 and Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())  then
		table.insert(codes,33403527)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403528)==0 and Duel.IsExistingMatchingCard(XY.maganethfilter8,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		table.insert(codes,33403528)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403529)==0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=4 then
		table.insert(codes,33403529)
		ck=1
   end
   if Duel.GetFlagEffect(tp,33403530)==0 and ck==1 then
		table.insert(codes,33403530)
   end
   if chk==0 then return ck==1 end
   table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.SetTargetParam(ac)
	Duel.RegisterFlagEffect(tp,ac,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	if ac==33403521 then  
	   e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	elseif ac==33403522 then 
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	elseif ac==33403523 then 
	   e:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	 elseif ac==33403524 then 
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_RECOVER)
	 elseif ac==33403525 then 
		 e:SetCategory(CATEGORY_CONTROL+CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	 elseif ac==33403526 then 
		 e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	elseif ac==33403527 then 
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOHAND)
	elseif ac==33403528 then 
	  e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	 elseif ac==33403529 then 
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TOHAND) 
	 elseif ac==33403530 then 
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	end
end
function XY.maganechop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cd=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local dr=0  
	local ck=0  
	local zy=0
	local ec=e:GetLabelObject() 
	local cg1=Group.CreateGroup()
	cg1:AddCard(ec)
	if cd==33403521 then  
		if  Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then 
			if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end 
			Duel.ConfirmCards(1-tp,cg1)  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)				   
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,1-tp,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
			 if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then  
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
			 Duel.SendtoGrave(g1,REASON_EFFECT) 
			 end	 
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(cd,3)) 
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1:SetTargetRange(LOCATION_MZONE,0)
					e1:SetTarget(XY.maganeetarget)
					e1:SetValue(XY.maganeefilter)
					e1:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e1,tp) 
				end
			 end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end
	elseif cd==33403522 then 
		 if  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then 
			if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil) 
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			 Duel.SendtoGrave(g,REASON_EFFECT)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
					Duel.SendtoGrave(g2,REASON_EFFECT)  
				end
			 end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end
	elseif cd==33403523 then 
		 if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)		
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
			 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil)
					Duel.SendtoDeck(g2,nil,2,REASON_EFFECT) 
				end
			 end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end
   elseif cd==33403524 then 
	if Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) then 
			if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)		  
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
			 if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				Duel.Draw(tp,2,REASON_EFFECT)  
			 end
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(XY.maganerefilter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
					local g2=Duel.SelectMatchingCard(tp,XY.maganerefilter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
					local tc=g2:GetFirst()
					local rec=tc:GetAttack()
					if tc:GetDefense()>rec then 
						rec=tc:GetDefense()
					end 
					Duel.Recover(tp,rec,REASON_EFFECT)
				end
			 end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end
   elseif cd==33403525 then 
	   if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)   
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
			 local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
			 if g3:GetCount()>0 then Duel.GetControl(g3,tp) end 
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(XY.maganespfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,XY.maganespfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g2,nil,tp,tp,false,false,POS_FACEUP)  
				end
			 end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end
   elseif cd==33403526 then 
	   if Duel.IsPlayerCanDraw(tp,2) then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end  
			Duel.ConfirmCards(1-tp,cg1)  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil) 
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
			if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 if Duel.Draw(tp,2,REASON_EFFECT)==2 then
				 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
				 local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
				 Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
			 end	  
			 local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CHANGE_DAMAGE)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,0)
				e2:SetValue(XY.maganeval6)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then	   
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(cd,3)) 
					local e0=Effect.CreateEffect(e:GetHandler())
					e0:SetType(EFFECT_TYPE_FIELD)
					e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
					e0:SetTargetRange(LOCATION_ONFIELD,0)
					e0:SetTarget(XY.maganeimlimit)
					e0:SetValue(aux.tgoval)
					e0:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e0,tp)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e1:SetTargetRange(LOCATION_ONFIELD,0)
					e1:SetTarget(XY.maganeimlimit)
					e1:SetValue(1)
					e1:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					Duel.RegisterEffect(e2,tp)
				end
			 end
			end
		   if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
	   end
   elseif cd==33403527 then 
	  if Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)		
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
	  if ck==0 then
				Duel.Hint(HINT_CARD,0,cd)
				Duel.Damage(1-tp,400,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISABLE)
				local g3=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
				local tc=g3:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end 
				if tc:IsType(TYPE_MONSTER) and tc:GetControler()==1-tp then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_SET_ATTACK_FINAL)
				e4:SetValue(0)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e5)   
				end   
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(XY.maganethfilter7,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=Duel.SelectMatchingCard(tp,XY.maganethfilter7,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
				Duel.SendtoHand(g1,tp,REASON_EFFECT)
				end
			 end
		 end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
		end  
   elseif cd==33403528 then 
	if Duel.IsExistingMatchingCard(XY.maganethfilter8,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)   
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
		if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter8,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			 local tc=g:GetFirst()
			 if tc then
				if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			 end								  
			 if Duel.IsExistingMatchingCard(XY.maganeckfilter83,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(XY.maganeckfilter81,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(XY.maganeckfilter82,tp,LOCATION_MZONE,0,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,XY.maganeckfilter83,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
				 if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					 local tc=Duel.GetMatchingGroup(XY.maganeckfilter81,tp,LOCATION_MZONE,0,nil):GetFirst()
					 local atk=Duel.GetMatchingGroup(XY.maganeckfilter82,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
					 local def=Duel.GetMatchingGroup(XY.maganeckfilter82,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetDefense)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(atk)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_DEFENSE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(def)
					tc:RegisterEffect(e1)
				 end
			  end
		end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)
	  end 
   elseif cd==33403529  then 
	 if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=4 then 
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			 Duel.ConfirmCards(1-tp,cg1)		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil)   
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end
	   if ck==0 then
			 Duel.Hint(HINT_CARD,0,cd)
			 Duel.Damage(1-tp,400,REASON_EFFECT)   
			local g1=Duel.GetDecktopGroup(tp,4)
			Duel.ConfirmCards(tp,g1)
			if g1:IsExists(XY.maganethfilter7,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(cd,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g1:FilterSelect(tp,XY.maganethfilter7,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.SortDecktop(tp,tp,3)
			else Duel.SortDecktop(tp,tp,4) 
			end  
		  local g2=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g2)
		  if g2:IsExists(XY.maganethfilter7,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(cd,3)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g2:FilterSelect(tp,XY.maganethfilter7,1,1,nil)
		  Duel.DisableShuffleCheck()
		  Duel.SendtoHand(sg,tp,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,sg)
		  Duel.ShuffleHand(tp)
		  Duel.SortDecktop(tp,1-tp,3)
		  else Duel.SortDecktop(tp,1-tp,4) 
		  end									   
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(cd,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
					  Duel.SendtoHand(g2,nil,REASON_EFFECT)
				end
			 end
		end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500*Duel.GetFlagEffect(tp,33423530))
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)		
	  end
  
   elseif cd==33403530  then
			 if  ec and Duel.SelectYesNo(1-tp,aux.Stringid(cd,1)) then 
				zy=1 
			end
			Duel.ConfirmCards(1-tp,cg1)  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			cg1:Select(1-tp,1,1,nil) 
			if  zy==1 and ec:GetCode()~=cd  then 
				ck=1			   
			end
			if zy==1 and ec:GetCode()==cd then 
				dr=1 
			end
			if ck==1 and (Duel.IsPlayerAffectedByEffect(tp,33403520) or Duel.IsPlayerAffectedByEffect(tp,33413520)) and Duel.GetFlagEffect(tp,33403520)==0 and Duel.SelectYesNo(tp,aux.Stringid(33403520,1)) then
				Duel.Hint(HINT_CARD,0,33403520)
				ck=0
				if not Duel.IsPlayerAffectedByEffect(tp,33403520) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=Duel.SelectMatchingCard(tp,XY.maganetgfilter,tp,LOCATION_HAND,0,1,1,nil)
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
				Duel.RegisterFlagEffect(tp,33403520,RESET_PHASE+PHASE_END,0,1)
			end  
   if ck==0 then	   
	   Duel.Hint(HINT_CARD,0,cd)
	   local codes={}
	   if   Duel.IsExistingMatchingCard(XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then   
			table.insert(codes,33403521)
	   end
	   if  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
			 table.insert(codes,33403522)
	   end
	   if  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
			table.insert(codes,33403523)
	   end
	   if  Duel.IsExistingMatchingCard(XY.maganethfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) then
			table.insert(codes,33403524)
	   end
	   if  Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)  then
			table.insert(codes,33403525)
	   end
	   if  Duel.IsPlayerCanDraw(tp,2)  then
			table.insert(codes,33403526)
	   end
	   if  Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())  then
			table.insert(codes,33403527)
	   end
	   if   Duel.IsExistingMatchingCard(XY.maganethfilter8,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
			table.insert(codes,33403528)
	   end
	   if  Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=4 then
			table.insert(codes,33403529)
	   end
		table.sort(codes)
		--c:IsCode(codes[1])
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			--or ... or c:IsCode(codes[i])
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_NOT}			  
		if ac==33403521 then	  
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
			 if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then  
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
			 Duel.SendtoGrave(g1,REASON_EFFECT) 
			 end	
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
					local c=e:GetHandler()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1:SetTargetRange(LOCATION_MZONE,0)
					e1:SetTarget(XY.maganeetarget)
					e1:SetValue(XY.maganeefilter)
					e1:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e1,tp) 
				end
			 end 
	   elseif ac==33403522 then 
			 Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			 Duel.SendtoGrave(g,REASON_EFFECT)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
				Duel.SendtoGrave(g2,REASON_EFFECT)  
				end
			 end					   
	   elseif  ac==33403523 then 
			 Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
			 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,3,nil)
				Duel.SendtoDeck(g2,nil,2,REASON_EFFECT) 
				end
			 end
	   elseif  ac==33403524 then   
				 Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			 local g=Duel.SelectMatchingCard(tp,XY.maganethfilter4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
			 if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			 Duel.Draw(tp,2,REASON_EFFECT)  
			 end
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(XY.maganerefilter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
					local g2=Duel.SelectMatchingCard(tp,XY.maganerefilter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
					local tc=g2:GetFirst()
					local rec=tc:GetAttack()
					if tc:GetDefense()>rec then 
						rec=tc:GetDefense() 
					end 
					Duel.Recover(tp,rec,REASON_EFFECT)
				end
			 end
	   elseif  ac==33403525 then  
				  Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
			 local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
			 if g3:GetCount()>0 then Duel.GetControl(g3,tp) end  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(XY.maganespfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,XY.maganespfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
				Duel.SpecialSummon(g2,nil,tp,tp,false,false,POS_FACEUP) 
				end
			 end
	   elseif  ac==33403526 then  
				 Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 if Duel.Draw(tp,2,REASON_EFFECT)==2 then
			 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			 local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			 Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
			 end	  
			 local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CHANGE_DAMAGE)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,0)
				e2:SetValue(XY.maganeval6)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					local e0=Effect.CreateEffect(e:GetHandler())
					e0:SetType(EFFECT_TYPE_FIELD)
					e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
					e0:SetTargetRange(LOCATION_ONFIELD,0)
					e0:SetTarget(XY.maganeimlimit)
					e0:SetValue(aux.tgoval)
					e0:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e0,tp)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e1:SetTargetRange(LOCATION_ONFIELD,0)
					e1:SetTarget(XY.maganeimlimit)
					e1:SetValue(1)
					e1:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					Duel.RegisterEffect(e2,tp)
				end
			 end
	   elseif   ac==33403527 then  
				 Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISABLE)
			 local g3=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			 local tc=g3:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end 
			   if tc:IsType(TYPE_MONSTER) and tc:GetControler()==1-tp then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_SET_ATTACK_FINAL)
				e4:SetValue(0)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
				local e5=e4:Clone()
				e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e5)   
			   end	  
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(XY.maganethfilter7,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=Duel.SelectMatchingCard(tp,XY.maganethfilter7,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
				Duel.SendtoHand(g1,tp,REASON_EFFECT)
				end
			 end
	   elseif  ac==33403528 then
				  Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,XY.maganethfilter8,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local tc=g:GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end  
			 if Duel.IsExistingMatchingCard(XY.maganeckfilter83,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(XY.maganeckfilter81,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(XY.maganeckfilter82,tp,LOCATION_MZONE,0,1,nil) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,XY.maganeckfilter83,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
					 local tc=Duel.GetMatchingGroup(XY.maganeckfilter81,tp,LOCATION_MZONE,0,nil):GetFirst()
					 local atk=Duel.GetMatchingGroup(XY.maganeckfilter82,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
					 local def=Duel.GetMatchingGroup(XY.maganeckfilter82,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetDefense)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(atk)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_DEFENSE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(def)
					tc:RegisterEffect(e1)
				end
			 end
	   elseif ac==33403529 then 
				Duel.Hint(HINT_CARD,0,ac)
			 Duel.Damage(1-tp,400,REASON_EFFECT)   
			local g1=Duel.GetDecktopGroup(tp,4)
			Duel.ConfirmCards(tp,g1)
			if g1:IsExists(XY.maganethfilter7,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(ac,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g1:FilterSelect(tp,XY.maganethfilter7,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.SortDecktop(tp,tp,3)
			else Duel.SortDecktop(tp,tp,4) 
			end  
		   local g2=Duel.GetDecktopGroup(1-tp,cm2)
		   Duel.ConfirmCards(tp,g2)
		  if g2:IsExists(XY.maganethfilter7,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(ac,3)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g2:FilterSelect(tp,XY.maganethfilter7,1,1,nil)
		  Duel.DisableShuffleCheck()
		  Duel.SendtoHand(sg,tp,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,sg)
		  Duel.ShuffleHand(tp)
		  Duel.SortDecktop(tp,1-tp,3)
		  else Duel.SortDecktop(tp,1-tp,4) 
		  end									   
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and  Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and 
			 Duel.SelectYesNo(tp,aux.Stringid(ac,2))	then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				end
			 end			
		end
	end   
			 local da=Duel.GetFlagEffect(tp,33423530)
			 if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and   Duel.SelectYesNo(tp,aux.Stringid(cd,2))  then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
				if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				   Duel.RegisterFlagEffect(tp,33423530,0,0,0)
				end
			end
			if dr==1 then 
				Duel.Draw(tp,1,REASON_EFFECT) 
				if  Duel.GetFlagEffect(tp,33423530)>0 and da>0 then 
				  Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400*da)
				end
			end
			Duel.RegisterFlagEffect(tp,cd,RESET_PHASE+PHASE_END,0,1)			
   end
end 
function XY.maganetgfilter(c)
	return c:IsCode(33403520)  and c:IsAbleToGrave()
end
function  XY.maganeetarget(e,c)
	return c:IsFaceup() and c:IsCode(33403520)
end
function XY.maganeefilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function XY.maganerefilter4(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetAttack()>0 or c:GetDefense()>0)
end
function XY.maganespfilter5(c,e,tp)
	return c:IsCode(33403520) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function XY.maganeval6(e,re,dam,r,rp,rc)
	if dam<=3000 then
		return 0
	else
		return dam
	end
end
function XY.maganeimlimit(e,c)
	return c:IsFaceup() and (c:IsSetCard(0x6349) or c:IsCode(33403520))
end
function XY.maganethfilter7(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520)) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function XY.maganethfilter8(c,e,tp)
	if not c:IsCode(33403520)  then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function XY.maganeckfilter81(c)  
	return c:IsFaceup() and c:IsCode(33403520)
end
function XY.maganeckfilter82(c)
	return (c:GetAttack()>0 or c:GetDefense()>0) and c:IsFaceup() and not c:IsCode(33403520)
end
function XY.maganeckfilter83(c,tp)  
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(XY.maganeckfilter81,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(XY.maganeckfilter82,tp,LOCATION_MZONE,0,1,c)
end


