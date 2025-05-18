if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s[0]=s[0] or {}
s.ct=s.ct or 0
function s.setfilter(c)
	if not c:IsType(TYPE_TRAP) then return false end
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do
		if (v:GetCode()~=EVENT_CHAINING and v:GetCode()~=EVENT_BECOME_TARGET) or v:GetProperty()&EFFECT_FLAG_DELAY~=0 then return false end
	end
	return c:IsSSetable(true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,POS_FACEDOWN)
	local sg2=Duel.GetDecktopGroup(tp,1):Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	sg1:Merge(sg2)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler()) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and #sg1>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg1,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	local res=0
	if tc and Duel.SSet(tp,tc,1-tp)~=0 then
		local sg1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,POS_FACEDOWN)
		local sg2=Duel.GetDecktopGroup(tp,1):Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
		if #sg1<=0 and #sg2<=0 then return end
		if #sg1>0 and (#sg2<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=sg1:Select(tp,1,1,nil)
			res=Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		else
			Duel.DisableShuffleCheck()
			res=Duel.Remove(sg2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
	if res==0 then return end
	local rc=Duel.GetOperatedGroup():GetFirst()
	if not rc:IsLocation(LOCATION_REMOVED) then return end
	rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,tc:GetFieldID())
	local le={tc:GetActivateEffect()}
	for _,v in pairs(le) do
		local e1=v:Clone()
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetRange(v:GetRange())
		local pro1,pro2=v:GetProperty()
		e1:SetProperty(pro1|EFFECT_FLAG_SET_AVAILABLE,pro2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1,true)
		local e1_1,e2,e3,e2_1=SNNM.ActivatedAsSpellorTrap(tc,TYPE_TRAP,v:GetRange(),true,e1)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCost(s.costchk)
		e3:SetOperation(s.costop)
	end
	if not rc:IsType(TYPE_TRAP) then return end
	local rfid=rc:GetFieldID()
	s[0][rfid]={}
	local te={rc:GetActivateEffect()}
	for _,v in pairs(te) do
		local cd=v:GetCode()
		local e4=v:Clone()
		e4:SetType(EFFECT_TYPE_QUICK_F)
		local pr1,pr2=v:GetProperty()
		e4:SetProperty(pr1&(~EFFECT_FLAG_DELAY),pr2)
		e4:SetCode(0x100000000+id+cd+(s.ct)*100000)
		e4:SetRange(LOCATION_HAND)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+0x1de0000)
		rc:RegisterEffect(e4,true)
		if cd==EVENT_FREE_CHAIN then
			s[0][rfid][e4]={nil,2,0,nil,0,2}
		else
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			if v:GetProperty()&EFFECT_FLAG_DELAY~=0 then ge1:SetProperty(EFFECT_FLAG_DELAY) end
			ge1:SetCode(cd)
			ge1:SetLabel(rfid)
			ge1:SetLabelObject(e4)
			ge1:SetOperation(s.check)
			Duel.RegisterEffect(ge1,0)
		end
		local e4_1,e5,e6,e5_1=SNNM.ActivatedAsSpellorTrap(rc,rc:GetOriginalType(),LOCATION_HAND,true,e4)
		e4_1:SetReset(RESET_EVENT+0x1de0000)
		e5:SetReset(RESET_EVENT+0x1de0000)
		e6:SetReset(RESET_EVENT+0x1de0000)
		e5_1:SetReset(RESET_EVENT+0x1de0000)
		s.ct=(s.ct)+1
	end
end
function s.costfilter(c,tp,fid)
	local res=false
	for _,flag in ipairs({c:GetFlagEffectLabel(id)}) do if flag==fid then res=true end end
	return res and c:IsFacedown() and c:IsAbleToHand(tp)
end
function s.costchk(e,te,tp)
	local c=e:GetHandler()
	if not c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN) and c:IsStatus(STATUS_SET_TURN) then return false end
	if Duel.GetCurrentChain()==0 then return false end
	local g=Duel.GetMatchingGroup(s.costfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil,Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_PLAYER),c:GetFieldID())
	return c:IsFacedown() and #g>0 and SNNM.AASTcostchk(c:GetOriginalType())(e,te,tp)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_PLAYER)
	local rc=Duel.GetFirstMatchingCard(s.costfilter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil,p,c:GetFieldID())
	local rfid=rc:GetFieldID()
	Duel.SendtoHand(rc,p,REASON_ACTION)
	Duel.ConfirmCards(1-p,rc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetLabel(rfid)
	e1:SetLabelObject(rc)
	e1:SetOperation(s.trop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	rc:CreateEffectRelation(e1)
	SNNM.AASTcostop(c:GetOriginalType())(e,tp,eg,ep,ev,re,r,rp)
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	s[0][e:GetLabel()][e:GetLabelObject()]={eg,ep,ev,re,r,rp}
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local rc=e:GetLabelObject()
	if not rc:IsRelateToEffect(e) or not rc:IsType(TYPE_TRAP) then return end
	local le=s[0][e:GetLabel()]
	for k,v in pairs(le) do
		local cd=k:GetCode()
		local teg,tep,tev,tre,tr,trp=table.unpack(v)
		teg=teg or Group.CreateGroup()
		tre=tre or Effect.GlobalEffect()
		Duel.RaiseEvent(teg,cd,tre,tr,trp,tep,tev)
	end
end
