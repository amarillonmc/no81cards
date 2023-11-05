--Hello World!
--Welcome to use MerlinTC's library.
--You can add QQ1252425371 to feedback bugs or proper your own lua.
MerlinTC=MerlinTC or {}
MerlinTC.loaded_metatable_list={}

--following function are all available

--MerlinTC.NumUP(ad,c,x,turn)
--MerlinTC.SSearch(c,code,fil,...)
--MerlinTC.SPSearch(c,code,fil,...)
--MerlinTC.FSSearch(c,code,fil,...)
--MerlinTC.Change(c,code)
--MerlinTC.Crystallize(c,code,cd,op,...)
--MerlinTC.ChessSPSummon(c,code)
--MerlinTC.lc1(e)
--MerlinTC.SAPlaceCounter(c,x,kind)

--Change Attack/Defence
--让c的atk/def（ad）上升x，持续turn回合。（turn==nil时，改为无限时间。）(ad==atk/def)
function MerlinTC.NumUP(ad,c,x,turn)
	local code=nil
	if ad==atk then
		code=EFFECT_UPDATE_ATTACK
	elseif ad==def then
		code=EFFECT_UPDATE_DEFENSE
	end
	if turn==nil then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(x)
		c:RegisterEffect(e1)
	else 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,turn)
		e1:SetValue(x)
		c:RegisterEffect(e1)
	end
end



--Search when summon/spsummon
--双招成功的场合(1)，从卡组把1张符合fil的卡加入手卡(s==summon,sp==spsummon,fs==flipsummon(1/0))
function MerlinTC.SSearch(c,code,fil,...)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,code)
	e1:SetTarget(MerlinTC.tg1)
	e1:SetOperation(MerlinTC.op1)
	c:RegisterEffect(e1)
end
function MerlinTC.SPSearch(c,code,fil,...)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,code)
	e1:SetTarget(MerlinTC.tg1)
	e1:SetOperation(MerlinTC.op1)
	c:RegisterEffect(e1)
end
function MerlinTC.FSSearch(c,code,fil,...)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e1:SetCountLimit(1,code)
	e1:SetTarget(MerlinTC.tg1)
	e1:SetOperation(MerlinTC.op1)
	c:RegisterEffect(e1)
end
function MerlinTC.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function MerlinTC.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--change a card
--把c变为卡密为code的卡（必须卡种相同）
function MerlinTC.Change(c,code)
	local token=Duel.CreateToken(tp,code)
	c:SetCardData(CARDDATA_CODE,code)
	c:ReplaceEffect(60002381,0)
	token.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(0xff)
	e1:SetValue(0xfffffff)
	c:RegisterEffect(e1)
	if token:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(token:GetAttribute())
		e1:SetRange(0xff)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(token:GetRace())
		e1:SetRange(0xff)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(token:GetType()-TYPE_TOKEN)
		e1:SetRange(0xff)
		c:RegisterEffect(e1)
		if c:IsType(TYPE_XYZ) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(token:GetRank())
			e1:SetRange(0xff)
			c:RegisterEffect(e1)
		elseif c:IsType(TYPE_LINK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_LINK)
			e1:SetValue(token:GetLink())
			e1:SetRange(0xff)
			c:RegisterEffect(e1)
			if token:IsLinkMarker(0x001) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x001)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x002) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x002)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x004) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x008)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x008) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x008)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x020) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x020)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x040) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x040)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x080) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x080)
				c:RegisterEffect(e1)
			elseif token:IsLinkMarker(0x100) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetRange(0xff)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
				e1:SetValue(0x100)
				c:RegisterEffect(e1)
			end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(token:GetLevel())
			e1:SetRange(0xff)
			c:RegisterEffect(e1)
		end
		if c:IsType(TYPE_PENDULUM) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(token:GetLeftScale())
			e1:SetRange(0xff)
			c:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_RSCALE)
			e1:SetValue(token:GetRightScale())
			e1:SetRange(0xff)
			c:RegisterEffect(e1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(token:GetBaseAttack())
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(token:GetBaseDefense())
		c:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(token:GetType())
		e1:SetRange(0xff)
		c:RegisterEffect(e1)
	end
end

--Special Effect of MerlinTC's Cards
--Havencraft
--结晶卡通用效果：把c放在魔陷区并放置cd个吟唱指示物
function MerlinTC.Crystallize(c,code,cd,op,...)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(MerlinTC.tg2)
	e2:SetOperation(MerlinTC.op2)
	c:RegisterEffect(e2)
end
function MerlinTC.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function MerlinTC.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		e:GetHandler():AddCounter(0x625,cd)
		Duel.RegisterFlagEffect(tp,60002177,RESET_PHASE+PHASE_END,0,1000) --结晶
		--cost
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e4:SetRange(LOCATION_SZONE)
		e4:SetOperation(MerlinTC.cost2)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e4)
		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_SZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e7:SetCondition(MerlinTC.con2)
		c:RegisterEffect(e7)
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function MerlinTC.cost2(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function MerlinTC.con2(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end


--Chess MagicianCraft
--西洋棋法（除国王）通用效果
function MerlinTC.ChessSPSummon(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	e1:SetCountLimit(1,code)
	e1:SetCondition(MerlinTC.con3)
	e1:SetOperation(MerlinTC.op3)
	c:RegisterEffect(e1)
end
function MerlinTC.con3(e,c)
	if c==nil then return true end
	local ub=2
	if Duel.IsPlayerAffectedByEffect(tp,60002113) then
		ub=1
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,60002113)
	return Duel.GetMZoneCount(tp,g)>0
		and g:GetCount()>=ub
end
function MerlinTC.op3(e,tp,eg,ep,ev,re,r,rp,c)
	local loc=e:GetHandler():GetLocation()
	local ub=2
	if Duel.IsPlayerAffectedByEffect(tp,60002113) then
		ub=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_ONFIELD,0,ub,ub,nil,60002113)
	Duel.SendtoGrave(g,REASON_COST)
	if loc~=LOCATION_HAND then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e:GetHandler():RegisterEffect(e1,true)
	end
end


--检测卡片是否位于第x列
function MerlinTC.lc1(e)
	return e:GetHandler():GetSequence()==0
end
function MerlinTC.lc2(e)
	return e:GetHandler():GetSequence()==1
end
function MerlinTC.lc3(e)
	return e:GetHandler():GetSequence()==2
end
function MerlinTC.lc4(e)
	return e:GetHandler():GetSequence()==3
end
function MerlinTC.lc5(e)
	return e:GetHandler():GetSequence()==4
end

--卡召唤/特殊召唤/发动时，给这张卡放置x个kind指示物
function MerlinTC.SAPlaceCounter(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(MerlinTC.tg4)
	e1:SetOperation(MerlinTC.op4)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(MerlinTC.tg4)
	e3:SetOperation(MerlinTC.op4)
	c:RegisterEffect(e3)
end
function MerlinTC.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x626)
end
function MerlinTC.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x626,1)
	end
end


--对方墓地是否有20张卡以上
function MerlinTC.YordC(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_GRAVE,nil)>=20
end






















