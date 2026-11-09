--Reflection Realm
function c33741123.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33741123,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33741123.tkcon)
	e1:SetTarget(c33741123.tktg)
	e1:SetOperation(c33741123.tkop)
	c:RegisterEffect(e1)
	if not c33741123.global_check then
		c33741123.global_check=true
		c33741123.summon_code,c33741123.atk_list={},{}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c33741123.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c33741123.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(ge3,0)
	end
end
function c33741123.clear(e,tp,eg,ep,ev,re,r,rp)
	c33741123.summon_code={}
end
function c33741123.codefilter(c,code)
	return c:GetOriginalCode()==code and c:IsFaceup()
end
function c33741123.checkop(e,tp,eg,ep,ev,re,r,rp)
	--if e:GetCode()==EVENT_CHAINING and (re:GetHandler():GetOriginalType()&TYPE_MONSTER)==0 then return end
	for tc in aux.Next(eg) do
		local rc=tc:GetOriginalCode()==tc:GetCode() and tc or Duel.GetFirstMatchingCard(c33741123.codefilter,0,0xff,0xff,nil,tc:GetCode())--replace
		if not rc then rc=Duel.CreateToken(0,tc:GetCode()) end
		local code,atk,def=rc:GetCode(),rc:GetTextAttack(),rc:GetTextDefense()
		if (rc:GetOriginalType()&TYPE_MONSTER)~=0 then
			table.insert(c33741123.summon_code,code)
			local eff=(rc:GetOriginalType()&TYPE_EFFECT)~=0 and true or false
			c33741123.atk_list[code]={}
			c33741123.atk_list[code][1],c33741123.atk_list[code][2],c33741123.atk_list[code][3]=atk,def,eff
		end
	end
end
function c33741123.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c33741123.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code_list={}
	for _,code in ipairs(c33741123.summon_code) do
		if Duel.IsPlayerCanSpecialSummonMonster(tp,33741079,0,TYPES_TOKEN_MONSTER,c33741123.atk_list[code][1],c33741123.atk_list[code][2],1,RACE_FIEND,ATTRIBUTE_DARK) then
			table.insert(code_list,code)
			if chk==0 then break end
		end
	end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and #code_list>0 end
	table.sort(code_list)
	--c:IsCode(codes[1])
	local afilter={code_list[1],OPCODE_ISCODE}
	if #code_list>1 then
		--or ... or c:IsCode(code_list[i])
		for i=2,#code_list do
			table.insert(afilter,code_list[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33741123.tkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33741079,0,TYPES_TOKEN_MONSTER,c33741123.atk_list[code][1],c33741123.atk_list[code][2],1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,33741079)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c33741123.atk_list[code][1])
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(c33741123.atk_list[code][2])
	token:RegisterEffect(e2)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	if c33741123.atk_list[code][3] then
		token:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_REMOVE_TYPE)
		e4:SetValue(TYPE_NORMAL)
		token:RegisterEffect(e4,true)
	end
	Duel.SpecialSummonComplete()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetOperation(c33741123.damop)
	token:RegisterEffect(e0,true)
end
function c33741123.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(1-c:GetPreviousControler(),c:GetPreviousAttackOnField(),REASON_EFFECT)
	e:Reset()
end
