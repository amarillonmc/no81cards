--血雳强袭队·满天星
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
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
function cm.isdir(c,x1,y1,tp,...)
	local x2,y2=cm.xylabel(c,tp)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.willbealllinkdir(lc,x0,y0,tp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and not Duel.IsExistingMatchingCard(cm.isdir,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,x0,y0,tp,list[i+1]*math.pi) then return false end
	end
	return true
end
function cm.islinkdirstate(c)
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_LINK)
	local g0=g:Filter(Card.IsControler,nil,0)
	local g1=g:Filter(Card.IsControler,nil,1)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for lc in aux.Next(g0) do
		local x0,y0=cm.xylabel(lc,0)
		local x,y=cm.xylabel(c,0)
		for i=0,8 do
			if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
		end
	end
	for lc in aux.Next(g1) do
		local x1,y1=cm.xylabel(lc,1)
		local x,y=cm.xylabel(c,1)
		for i=0,8 do
			if lc:IsLinkMarker(1<<i) and cm.fieldline(x1,y1,x,y,list[i+1]*math.pi) then return true end
		end
	end
	return false
end
function cm.willbelinkdir(c,x0,y0,tp)
	local x,y=cm.xylabel(c,tp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
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
function cm.get_zone(c,tp)
	local zone=0
	for x=0,4 do
		if cm.willbealllinkdir(c,x,1,tp) then zone=zone|(1<<x) end
	end
	if cm.willbealllinkdir(c,1,2,tp) then zone=zone|0x20 end
	if cm.willbealllinkdir(c,3,2,tp) then zone=zone|0x40 end
	return zone
end
function cm.tgfilter(c,e)
	return c:IsType(TYPE_LINK) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.spfilter(c,e,tp,g)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not g or (Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsLink(math.ceil(#g/2))))
end
function cm.spfilter1(c,e,tp,lk)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLink(lk)
end
function cm.fselect(g,e,tp,tg)
	return tg:IsExists(cm.spfilter,1,nil,e,tp,g) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or g:IsExists(function(c) return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 end,1,nil))
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,e)
	local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chkc then return cg:IsContains(chkc) end
	if chk==0 then
		return cg:CheckSubGroup(cm.fselect,1,maxlink*2,e,tp,tg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=cg:SelectSubGroup(tp,cm.fselect,false,1,maxlink*2,e,tp,tg)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local lk=math.ceil(#og/2) --:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk):GetFirst()
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
	end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cm.spfilter2(c,e,tp)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone=0
	for i=0,4 do
		for lc in aux.Next(lg) do
			if cm.islinkdir(lc,i,1,tp) and Duel.CheckLocation(tp,LOCATION_MZONE,i) then zone=zone|(1<<i) end
		end
	end
	return c:IsRace(RACE_PYRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local q1=#g>0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 or q1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bool=c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsFaceup()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local q2=bool and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local q1=#g>0
	if not q1 and not q2 then return end
	local opt=aux.SelectFromOptions(tp,{q1,aux.Stringid(m,1)},{q2,aux.Stringid(m,2)})
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			local zone=0
			for i=0,4 do
				for lc in aux.Next(lg) do
					if cm.islinkdir(lc,i,1,tp) and Duel.CheckLocation(tp,LOCATION_MZONE,i) then zone=zone|(1<<i) end
				end
			end
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		end
		local bool=c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsFaceup()
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
			if s<0xffff then
				Duel.MoveSequence(c,nseq)
			else
				Duel.GetControl(c,1-tp,0,0,s>>16)
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
		if s<0xffff then
			Duel.MoveSequence(c,nseq)
		else
			Duel.GetControl(c,1-tp,0,0,s>>16)
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
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		local q1=#g>0
		if q1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				local zone=0
				for i=0,4 do
					for lc in aux.Next(lg) do
						if cm.islinkdir(lc,i,1,tp) and Duel.CheckLocation(tp,LOCATION_MZONE,i) then zone=zone|(1<<i) end
					end
				end
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			end
		end
	end
end