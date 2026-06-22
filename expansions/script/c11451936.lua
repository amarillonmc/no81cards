--血雳强袭队·勿忘我
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_BATTLE_END+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+6)
	e2:SetCondition(cm.mcon)
	e2:SetTarget(cm.mtg)
	e2:SetOperation(cm.mop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.spfilter(c,e,tp,link)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLink(link) and c:IsLinkAbove(2)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local link=math.ceil((Duel.GetCurrentChain()+1)/2)
	local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,link)
	if chk==0 then return #tg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lk=math.ceil(Duel.GetCurrentChain()/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--type
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_EQUIP+TYPE_TRAP)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCondition(cm.discon)
		e3:SetOperation(cm.disop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local lc=e:GetHandler()
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD==0 or rp==tp then return false end
	local x=seq
	local y=0
	if p==tp then
		if loc&LOCATION_MZONE>0 and x<=4 then y=1
		elseif loc&LOCATION_MZONE>0 and x==5 then x,y=1,2
		elseif loc&LOCATION_MZONE>0 and x==6 then x,y=3,2
		elseif loc&LOCATION_SZONE>0 and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif p==1-tp then
		if loc&LOCATION_MZONE>0 and x<=4 then x,y=4-x,3
		elseif loc&LOCATION_MZONE>0 and x==5 then x,y=3,2
		elseif loc&LOCATION_MZONE>0 and x==6 then x,y=1,2
		elseif loc&LOCATION_SZONE>0 and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return cm.islinkdir(lc,x,y,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
function cm.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.willbelinkdir(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.islinkdir(lc,x,y,tp)
	if lc:IsControler(1-tp) then x,y=4-x,4-y end
	local x0,y0=cm.xylabel(lc,lc:GetControler())
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.sp_filter(e)
	return e:IsHasCategory(CATEGORY_EQUIP)
end
function cm.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsOriginalEffectProperty(cm.sp_filter)
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local q1=Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g>0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 or q1 end
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bool=c:IsRelateToEffect(e) and c:IsFaceup()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local q2=bool and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local qg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local q1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #qg>0
	if not q1 and not q2 then return end
	local opt=aux.SelectFromOptions(tp,{q1,aux.Stringid(m,1)},{q2,aux.Stringid(m,2)})
	if opt==1 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=qg:Select(tp,1,1,nil)
		if #sg>0 then
			local tc=sg:GetFirst()
			if Duel.Equip(tp,tc,tg:GetFirst()) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(cm.eqlimit)
				e1:SetLabelObject(tg:GetFirst())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_EQUIP+TYPE_TRAP)
				tc:RegisterEffect(e2)
			end
		end
		local bool=c:IsRelateToEffect(e) and c:IsFaceup()
		local seq=c:GetSequence()
		local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
		local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
		local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
		local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
		local q2=bool and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0
		if q2 then
			Duel.BreakEffect()
			local flag=0
			if b1 then flag=bit.replace(flag,0x1,seq-1) end
			if b2 then flag=bit.replace(flag,0x1,seq+1) end
			if b3 then if seq==5 then flag=flag|0x2 else flag=flag|0x8 end end
			if b4 then if seq==1 then flag=flag|0x20 else flag=flag|0x40 end end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x600060)
			local nseq=math.log(s&0xff,2)
			local mv=(s<=0xffff and c:IsControler(tp)) or (s>0xffff and c:IsControler(1-tp))
			local zone=(s<=0xffff and s&0xff) or (s>0xffff and s>>16)
			if mv then
				Duel.MoveSequence(c,nseq)
			else
				Duel.GetControl(c,1-c:GetControler(),0,0,zone)
				c:RegisterFlagEffect(m,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD,0,1)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e6:SetCode(EVENT_CHAIN_SOLVED)
				e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
									if c:GetFlagEffect(m)~=0 then
										return Duel.GetCurrentChain()==1
									else
										e:Reset()
										return false
									end
								end)
				e6:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
									if c:GetFlagEffect(m)~=0 and c:IsLocation(LOCATION_MZONE) then
										Duel.Destroy(c,REASON_EFFECT)
									end
								end)
				e6:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e6,tp)
				local e7=e6:Clone()
				e7:SetCode(EVENT_CHAIN_NEGATED)
				Duel.RegisterEffect(e7,tp)
			end
		end
	elseif opt==2 then
		local flag=0
		if b1 then flag=bit.replace(flag,0x1,seq-1) end
		if b2 then flag=bit.replace(flag,0x1,seq+1) end
		if b3 then if seq==5 then flag=flag|0x2 else flag=flag|0x8 end end
		if b4 then if seq==1 then flag=flag|0x20 else flag=flag|0x40 end end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x600060)
		local nseq=math.log(s&0xff,2)
		local mv=(s<=0xffff and c:IsControler(tp)) or (s>0xffff and c:IsControler(1-tp))
		local zone=(s<=0xffff and s&0xff) or (s>0xffff and s>>16)
		if mv then
			Duel.MoveSequence(c,nseq)
		else
			Duel.GetControl(c,1-c:GetControler(),0,0,zone)
			c:RegisterFlagEffect(m,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD,0,1)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_CHAIN_SOLVED)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
								if c:GetFlagEffect(m)~=0 then
									return Duel.GetCurrentChain()==1
								else
									e:Reset()
									return false
								end
							end)
			e6:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
								if c:GetFlagEffect(m)~=0 and c:IsLocation(LOCATION_MZONE) then
									Duel.Destroy(c,REASON_EFFECT)
								end
							end)
			e6:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e6,tp)
			local e7=e6:Clone()
			e7:SetCode(EVENT_CHAIN_NEGATED)
			Duel.RegisterEffect(e7,tp)
		end
		local qg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local q1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #qg>0
		if q1 then
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=g:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tg=qg:Select(tp,1,1,nil)
			if #sg>0 then
				local tc=sg:GetFirst()
				if Duel.Equip(tp,tg:GetFirst(),c) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(cm.eqlimit)
					e1:SetLabelObject(tg:GetFirst())
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetCode(EFFECT_CHANGE_TYPE)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e2:SetValue(TYPE_EQUIP+TYPE_TRAP)
					tc:RegisterEffect(e2)
				end
			end
		end
	end
end