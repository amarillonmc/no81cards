--放课后冰雪女孩！
function c28335633.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28335633.cost)
	e1:SetTarget(c28335633.target)
	e1:SetOperation(c28335633.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28335633,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28335633.tdcon)
	e2:SetCost(c28335633.tdcost)
	e2:SetTarget(c28335633.tdtg)
	e2:SetOperation(c28335633.tdop)
	c:RegisterEffect(e2)
end
function c28335633.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28335633.chkfilter(c,tp)
	return c:IsSetCard(0x286) and not c:IsPublic() and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x286,TYPES_TOKEN_MONSTER+TYPE_TUNER,2000,2000,4,RACE_AQUA,c:GetAttribute()) and c:IsType(TYPE_MONSTER)
end
function c28335633.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c28335633.chkfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.GetMZoneCount(tp)>0 end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		local ft=Duel.GetMZoneCount(tp)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c28335633.chkfilter,tp,LOCATION_HAND,0,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ft)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
		local tab={}
		local ct=0
		for tc in aux.Next(cg) do
			ct=ct+2
			tab[ct-1]=tc:GetCode()
			tab[ct]=tc:GetAttribute()
			tc:RegisterFlagEffect(28335633,0,0,0,ct/2)
		end
		e:SetLabel(table.unpack(tab))
		cg:KeepAlive()
		e:SetLabelObject(cg)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,#cg,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#cg,0,0)
	end
end
function c28335633.indexfilter(c,ct)
	return c:GetFlagEffectLabel(28335633)==ct
end
function c28335633.activate(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	local cg=e:GetLabelObject()
	local a={}
	local c={}
	local ct=0
	for i,v in ipairs(tab) do
		if i%2==1 then
			ct=ct+1
			c[ct]=v
		else
			a[ct]=v
		end
	end
	for i=1,ct do
		local code=c[i]
		local attr=a[i]
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x286,TYPES_TOKEN_MONSTER+TYPE_TUNER,2000,2000,4,RACE_AQUA,attr) then
			local tc=cg:Filter(c28335633.indexfilter,nil,i):GetFirst()
			tc:ResetFlagEffect(28335633)
			cg:RemoveCard(tc)
		end
	end
	if #cg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=cg:Clone()
	if #cg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28335633,0))
		sg=cg:Select(tp,ft,ft,nil)
	end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for tc in aux.Next(sg) do
		local i=tc:GetFlagEffectLabel(28335633)
		local code=c[i]
		local attr=a[i]
		local token=Duel.CreateToken(tp,28335634)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attr)
		token:RegisterEffect(e2)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		--[[local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetValue(c28335633.fuslimit)
		token:RegisterEffect(e5)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e6)]]
		token:RegisterFlagEffect(28335633,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(cg) do
		tc:ResetFlagEffect(28335633)
	end
	cg:DeleteGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c28335633.descon)
	e1:SetOperation(c28335633.desop)
	Duel.RegisterEffect(e1,tp)
end
function c28335633.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function c28335633.desfilter(c,fid)
	return c:GetFlagEffectLabel(28335633)==fid
end
function c28335633.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not (g and g:IsExists(c28335633.desfilter,1,nil,e:GetLabel())) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c28335633.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c28335633.desfilter,nil,e:GetLabel())
	--g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function c28335633.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c28335633.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c28335633.tdfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToDeck() and c:IsAbleToHand() and c:IsFaceupEx()
end
function c28335633.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x30) and c28335633.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c28335633.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and Duel.IsPlayerCanDraw(tp,1) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,c28335633.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	local num=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and 1 or 0
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount()+num,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c28335633.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	local g=Duel.GetTargetsRelateToChain()
	if #tg>0 then g:Merge(tg) end
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
