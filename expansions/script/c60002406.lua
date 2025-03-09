--奇术尊者 优树
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	--e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.bkop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
	if not cm.NecroceanCheck then
		cm.NecroceanCheck=true
		local ne1=Effect.CreateEffect(c)
		ne1:SetType(EFFECT_TYPE_SINGLE)
		ne1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
		ne1:SetCondition(cm.syncon)
		ne1:SetCode(EFFECT_HAND_SYNCHRO)
		ne1:SetTargetRange(0,1)
		local ne2=Effect.CreateEffect(c)
		ne2:SetType(EFFECT_TYPE_SINGLE)
		ne2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
		ne2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ne2:SetCondition(cm.syncon)
		ne2:SetTarget(cm.syntg)
		ne2:SetValue(1)
		ne2:SetOperation(cm.synop)
		local ne3=Effect.CreateEffect(c)
		ne3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ne3:SetTargetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
		ne3:SetTarget(cm.eftg)
		ne3:SetLabelObject(ne1)
		Duel.RegisterEffect(ne3,tp)
		local ne4=ne3:Clone()
		ne4:SetLabelObject(ne2)
		Duel.RegisterEffect(ne4,tp)
	end
end
function cm.eftg(e,c)
	return Duel.GetFlagEffect(0,m+53752000)+Duel.GetFlagEffect(1,m+53752000)>0
end
function cm.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function cm.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(cm.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(cm.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(cm.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,99,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsOnField() then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
end
function cm.filter(c,tp)
	local ocheck=false
	if c:GetOriginalCode()==53752002 or (c:GetOriginalCode()>=53752008 and c:GetOriginalCode()<=53752013) then
		Duel.RegisterFlagEffect(tp,m+53752000,0,0,1)
		if c:IsSynchroSummonable(nil) then ocheck=true end
	end
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	return c:IsSynchroSummonable(nil,mg) or ocheck==true
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(0,m)
	local g=Duel.GetDecktopGroup(tp,num)
	--Debug.Message(Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,tp))
	--Debug.Message(g:GetCount()>=num)
	--Debug.Message(Duel.GetMZoneCount(tp)>0)
	local gc=false
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,tp) then gc=true end
	if Duel.GetFlagEffect(tp,m+53752000)~=0 then Duel.ResetFlagEffect(tp,m+53752000) end
	return gc and g:GetCount()>=num and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetMZoneCount(tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(0,m)
	if Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.ConfirmDecktop(tp,num)
		local g=Duel.GetDecktopGroup(tp,num):Filter(Card.IsSetCard,nil,0xc620)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then
				if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
					local ssg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,tp)
					local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
					local spc=ssg:Select(tp,1,1,nil):GetFirst()
					if Duel.GetMZoneCount(tp,c)>0 then
						local b1=false
						local b2=false
						Duel.RegisterFlagEffect(tp,m+53752000,0,0,1)
						if spc:GetOriginalCode()==53752002 or (spc:GetOriginalCode()>=53752008 and spc:GetOriginalCode()<=53752013) and spc:IsSynchroSummonable(nil) then b1=true end
						Duel.ResetFlagEffect(tp,m+53752000)
						if spc:IsSynchroSummonable(nil,mg) then b2=true end
						local op=aux.SelectFromOptions(tp,
							{b1,aux.Stringid(60002404,1)},
							{b2,aux.Stringid(60002404,2)})
						if op==1 then
							Duel.RegisterFlagEffect(tp,m+53752000,0,0,1)
							Duel.SynchroSummon(tp,spc,nil)
							Duel.ResetFlagEffect(tp,m+53752000)
						elseif op==2 then
							Duel.SynchroSummon(tp,spc,nil,mg)
						end
					end
				end
			else
				Duel.SendtoGrave(sg,REASON_RULE)
			end
			Duel.ShuffleDeck(tp)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end