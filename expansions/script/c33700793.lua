--丸吞
function c33700793.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(c33700793.cost)
	c:RegisterEffect(e1)	
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700793,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c33700793.spcon)
	e2:SetCost(c33700793.spcost)
	e2:SetTarget(c33700793.sptg)
	e2:SetOperation(c33700793.spop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--dam
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetDescription(aux.Stringid(33700793,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c33700793.damcon)
	e5:SetTarget(c33700793.damtg)
	e5:SetOperation(c33700793.damop)
	c:RegisterEffect(e5)
	e5:SetLabelObject(e1)
end
function c33700793.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c33700793.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabelObject():GetCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*2000)
end
function c33700793.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c33700793.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandlerPlayer() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c33700793.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c33700793.spfilter(c,e,tp,fid)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffectLabel(33700793)==fid
end
function c33700793.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=e:GetLabelObject():GetLabelObject()
	local fid=e:GetLabelObject():GetLabel()
	if chk==0 then 
	   if e:GetLabel()~=1 then e:SetLabel(0) return false end
	   return (Duel.CheckLPCost(tp,1000) or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0) and g:IsExists(c33700793.spfilter,1,nil,e,tp,fid) and c:GetFlagEffect(33700893)==0
	end
	c:RegisterFlagEffect(33700893,RESET_CHAIN,0,1)
	local ac=0
	local costlp=0
	local costgp=Group.CreateGroup()
	local i=0
	local sg=g:Filter(c33700793.spfilter,nil,e,tp,fid)
	local sgct=sg:GetCount()
	repeat 
		i=i+1
		if ac==1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then break end
		local lpct=math.floor(Duel.GetLP(tp)/1000)
		lpct=math.min(sgct-ac,lpct-ac)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		   lpct=math.min(lpct,1)
		end
		local b1=lpct>0
		local cardct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,costgp)
		cardct=math.min(sgct-ac,cardct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		   cardct=math.min(cardct,1)
		end
		local b2=cardct>0
		if not b1 and not b2 then break end
		local t={}
		for i=1,lpct do
			t[i]=i*1000
		end
		local off=1
		local ops={}
		local opval={}
	   if b1 then
		   ops[off]=aux.Stringid(33700793,2)
		   opval[off-1]=1
		   off=off+1
	   end
	   if b2 then
		   ops[off]=aux.Stringid(33700793,3)
		   opval[off-1]=2
		   off=off+1
	   end
	   if i>1 then
		   ops[off]=aux.Stringid(33700793,1)
		   opval[off-1]=3
		   off=off+1
	   end
	   local op=Duel.SelectOption(tp,table.unpack(ops))
	   local sel=opval[op]
	   if sel==1 then
		   local lpct2=Duel.AnnounceNumber(tp,table.unpack(t))
		   ac=ac+lpct2/1000
		   costlp=costlp+lpct2
	   elseif sel==2 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local costgp2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,cardct,costgp)
		   local costgpct=costgp2:GetCount()
		   ac=ac+costgpct
		   costgp:Merge(costgp2)
	   else
		   break 
	   end
	until ac==sgct
	if costlp>0 then
	   Duel.PayLPCost(tp,costlp)
	end
	if costgp then
	   Duel.SendtoHand(costgp,1-tp,REASON_EFFECT)
	   Duel.ShuffleHand(tp)
	   Duel.ShuffleHand(1-tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=sg:Select(tp,ac,ac,nil)
	Duel.SetTargetCard(sg2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg2,sg2:GetCount(),0,0)
end
function c33700793.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
	   Duel.Destroy(c,REASON_EFFECT)
	end
end
function c33700793.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetReleaseGroup(1-tp)
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:Select(tp,1,99,nil)
	Duel.Release(g,REASON_COST)
	local fid=c:GetFieldID()
	e:SetLabel(fid)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(33700793,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	g:KeepAlive()
	e:SetLabelObject(g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabel(g:GetCount())
	e1:SetCondition(c33700793.tgcon)
	e1:SetOperation(c33700793.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(33700793,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,3)
	c33700793[e:GetHandler()]=e1
end
function c33700793.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c33700793.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(33700793)
		Duel.Recover(tp,e:GetLabel()*1000,REASON_EFFECT)
	end
end
