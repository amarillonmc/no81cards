local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
local IO_CHECK=false
if io then IO_CHECK=true end
local tableclone=function(tab,mytab)
	local res=mytab or {}
	for i,v in pairs(tab) do res[i]=v end
	return res
end
local _Card=tableclone(Card)
local _Duel=tableclone(Duel)
local _Effect=tableclone(Effect)
local _Group=tableclone(Group)
local _Debug=tableclone(Debug)
local _Auxiliary=tableclone(Auxiliary)
local _pcall=pcall
local _error=error
function logWarning(msg)
	local _,err = _pcall(function()
		_error(msg,5)
	end)
	Debug.Message(err)
end
function s.initial_effect(c)
	local control_player=0
	if _Duel.GetFieldGroupCount(1,LOCATION_DECK,0)>0 then control_player=1 end
	local CardCount=_Duel.GetMatchingGroupCount(s.cfilter,control_player,LOCATION_EXTRA,0,nil,id)
	if _G.dealergame==true and KOISHI_CHECK then
		s.globle_check=true
		_G.dealerplayer=control_player
		_Debug.SetPlayerInfo(control_player,8000,0,0)
		_Debug.SetPlayerInfo(1-control_player,8000,0,0)
	elseif CardCount==1 then
		s.Wild_Mode=true
		if KOISHI_CHECK then
			function Card.RegisterEffect(ec,e,bool)
				if s.cfilter(ec,id) then
					return _Card.RegisterEffect(ec,e,bool)
				else
					local ge0=Effect.CreateEffect(ec)
					ge0:SetType(EFFECT_TYPE_SINGLE)
					ge0:SetCode(EFFECT_CANNOT_SSET)
					_Card.RegisterEffect(ec,ge0,true)
					local ge1=Effect.CreateEffect(ec)
					ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					ge1:SetCode(EVENT_DRAW)
					ge1:SetOperation(s.changecardcode)
					return _Card.RegisterEffect(ec,ge1,true)
				end
			end
			local dg=_Duel.GetFieldGroup(control_player,0,LOCATION_DECK)
			for tc in aux.Next(dg) do
				s.resetcard(tc)
			end
			local ge0=Effect.GlobalEffect()
			ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge0:SetCode(EVENT_DRAW)
			ge0:SetOperation(s.changecardcode)
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge1:SetTargetRange(0,LOCATION_DECK+LOCATION_HAND)
			ge1:SetLabelObject(ge0)
			_Duel.RegisterEffect(ge1,control_player)
		end
	elseif CardCount==2 and KOISHI_CHECK then
		_Duel.DisableActionCheck(true)
		_Debug.SetPlayerInfo(control_player,8000,0,1)
		_Debug.SetPlayerInfo(1-control_player,8000,0,1)
		local dame1=_Effect.GlobalEffect()
		_Effect.SetType(dame1,2)
		_Effect.SetProperty(dame1,0x800)
		_Effect.SetCode(dame1,82)
		_Effect.SetTargetRange(dame1,1,0)
		_Effect.SetValue(dame1,0)
		_Duel.RegisterEffect(dame1,control_player)
		local dame2=_Effect.Clone(dame1)
		_Effect.SetCode(dame2,37564153)
		_Effect.SetValue(dame2,1)
		_Duel.RegisterEffect(dame2,control_player)
		local dame3=_Effect.Clone(dame2)
		_Duel.RegisterEffect(dame3,1-control_player)
		--local movet = coroutine.create(Duel.MoveTurnCount)
		--coroutine.resume(movet)
		--local move1 = coroutine.create(Duel.MoveToField)
		--coroutine.resume(move1,c,control_player,control_player,LOCATION_MZONE,POS_FACEUP_ATTACK,true,0x20)
		--local re = coroutine.create(Duel.Recover)
		--coroutine.resume(re,1-control_player,2147483647,REASON_RULE)
		--local pl = coroutine.create(Duel.PayLPCost)
		--coroutine.resume(pl,1-control_player,2147483647,true)
		--local dam = coroutine.create(Duel.Damage)
		--coroutine.resume(dam,1-control_player,2147483647,REASON_RULE)
		--pcall(_Duel.MoveTurnCount)
		local ge1=_Effect.GlobalEffect()		  
		_Effect.SetType(ge1,2)
		_Effect.SetCode(ge1,37564154)
		_Effect.SetTargetRange(ge1,1,0)
		_Effect.SetProperty(ge1,0x800)
		_Effect.SetValue(ge1,100)
		_Duel.RegisterEffect(ge1,control_player)
		local cg=_Duel.GetMatchingGroup(s.cfilter,control_player,LOCATION_EXTRA,0,nil,id)
		local tc1=_Group.GetFirst(cg)
		local tc2=_Group.GetNext(cg)
		_pcall(_Duel.MoveToField,tc1,control_player,control_player,4,1,true,1)
		s.atkfun(tc1)
		_pcall(_Duel.MoveToField,tc2,control_player,control_player,4,1,true,16)
		s.atkfun(tc2)
		_pcall(_Duel.MoveToField,c,control_player,control_player,4,1,true,4)
		s.atkfun(c)
		local e1=_Effect.CreateEffect(c)
		_Effect.SetType(e1,EFFECT_TYPE_FIELD)
		_Effect.SetCode(e1,EFFECT_REVERSE_DAMAGE)
		_Effect.SetRange(e1,LOCATION_MZONE)
		_Effect.SetProperty(e1,EFFECT_FLAG_PLAYER_TARGET)
		_Effect.SetTargetRange(e1,1,1)
		_Effect.SetLabelObject(e1,dame3)
		_Effect.SetValue(e1,s.rev)
		_Card.RegisterEffect(c,e1)
		_Effect.Reset(dame2)
		if not s.IsDraw then
			s.IsDraw=true
			_pcall(_Duel.Draw,control_player,5,0x400)
			_pcall(_Duel.Draw,1-control_player,5,0x400)
		end
		_Duel.DisableActionCheck(false)
	end
	if not s.globle_check then
		if not Group.ForEach then
			function Group.ForEach(g,f,...)
				for tc in aux.Next(g) do
					f(tc,...)
				end
				logWarning("Group.ForEach已经废弃了，发牌姬已暂时为您处理")
			end
		end
		function Effect.CreateEffect(ec)
			if ec==nil then
				logWarning("是不是忘了定义c了？发牌姬已代替创建效果")
				return _Effect.CreateEffect(c)
			end
			if aux.GetValueType(ec)=="Group" then
				logWarning("参数不能是卡片组！发牌姬已代替创建效果")
				if #ec>0 then
					return _Effect.CreateEffect(ec:GetFirst())
				else
					return _Effect.CreateEffect(c)
				end
			end
			return _Effect.CreateEffect(ec)
		end
		function Duel.GetMatchingGroup(f,tp,...)
			if tp==nil and s.Hint_Mode then logWarning("疑似出现tp笑话，请检查tp是否为nil!") end
			return _Duel.GetMatchingGroup(f,tp,...)
		end
		function Duel.GetLocationCount(tp,...)
			if tp==nil and s.Hint_Mode then logWarning("疑似出现tp笑话，请检查tp是否为nil!") end
			return _Duel.GetLocationCount(tp,...)
		end
		function Duel.RegisterEffect(e,tp,...)
			if tp==nil and s.Hint_Mode then logWarning("疑似出现tp笑话，请检查tp是否为nil!") end
			return _Duel.RegisterEffect(e,tp,...)
		end
		function Card.IsCanBeSpecialSummoned(sc,e,sumtype,tp,...)
			if (e==nil or tp==nil) and s.Hint_Mode then logWarning("特招检测似乎忘了传参了") end
			return _Card.IsCanBeSpecialSummoned(sc,e,sumtype,tp,...)
		end
		s.autodata={
			lp={8000,8000},
			turn=0,
			cards={{},{}},  
		}
		s.manualdata={
			lp={8000,8000},
			turn=0,
			cards={{},{}},  
		}

		s.globle_check=true
		s.Cheating_Mode=false
		s.Hint_Mode=true
		s.Control_Mode=false
		s.Wild_Mode=false
		s.Random_Mode=false
		s.Developer_Mode=false
		s.password={false,false,false,false,false}
		s.cheaktable={}
		s.controltable={}

		s.SummonCheckEffect={}
		s.SummonCheckEffect[1]=Effect.GlobalEffect()
		s.SummonCheckEffect[1]:SetType(EFFECT_TYPE_CONTINUOUS)
		s.SummonCheckEffect[1]:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		s.SummonCheckEffect[1]:SetTarget(s.sumtarget2)
		Duel.RegisterEffect(s.SummonCheckEffect[1],1)
		s.SummonCheckEffect[0]=s.SummonCheckEffect[1]:Clone()
		Duel.RegisterEffect(s.SummonCheckEffect[0],0)
		
		--SpecialSummon from ex--for check
		s.SpecialSummonCheckEffect={}
		s.SpecialSummonCheckEffect[1]=Effect.GlobalEffect()
		s.SpecialSummonCheckEffect[1]:SetType(EFFECT_TYPE_CONTINUOUS)
		s.SpecialSummonCheckEffect[1]:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		s.SpecialSummonCheckEffect[1]:SetTarget(s.sptarget2)
		Duel.RegisterEffect(s.SpecialSummonCheckEffect[1],1)
		s.SpecialSummonCheckEffect[0]=s.SpecialSummonCheckEffect[1]:Clone()
		Duel.RegisterEffect(s.SpecialSummonCheckEffect[0],0)

		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_DRAW)
		ge0:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge0:SetOperation(s.startop)
		Duel.RegisterEffect(ge0,0)
		local cge0=ge0:Clone()
		cge0:SetCode(EVENT_PREDRAW)
		Duel.RegisterEffect(cge0,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.adjustcon)
		ge1:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge1,0)
		--save
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PREDRAW)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.saveop)
		Duel.RegisterEffect(ge2,0)
		--hint
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetCondition(s.hintcon)
		ge3:SetOperation(s.hintop)
		Duel.RegisterEffect(ge3,0)

		--save rg
		s.sumgroup=Group.CreateGroup()
		s.sumgroup:KeepAlive()
		local sge1=Effect.CreateEffect(c)
		sge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		sge1:SetCode(EVENT_SUMMON)
		sge1:SetOperation(s.sumop)
		Duel.RegisterEffect(sge1,0)
		local sge2=sge1:Clone()
		sge2:SetCode(EVENT_FLIP_SUMMON)
		Duel.RegisterEffect(sge2,0)
		local sge3=sge1:Clone()
		sge3:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(sge3,0)

		s.sumsgroup=Group.CreateGroup()
		s.sumsgroup:KeepAlive()
		local sge4=Effect.CreateEffect(c)
		sge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		sge4:SetCode(EVENT_SUMMON_SUCCESS)
		sge4:SetOperation(s.sumsop)
		Duel.RegisterEffect(sge1,0)
		local sge5=sge4:Clone()
		sge5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(sge5,0)
		local sge6=sge4:Clone()
		sge6:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(sge6,0)
	end
end
local msg_map = {
	[1] = "MSG_RETRY",
	[2] = "MSG_HINT",
	[3] = "MSG_WAITING",
	[4] = "MSG_START",
	[5] = "MSG_WIN",
	[6] = "MSG_UPDATE_DATA",
	[7] = "MSG_UPDATE_CARD",
	[8] = "MSG_REQUEST_DECK",
	[10] = "MSG_SELECT_BATTLECMD",
	[11] = "MSG_SELECT_IDLECMD",
	[12] = "MSG_SELECT_EFFECTYN",
	[13] = "MSG_SELECT_YESNO",
	[14] = "MSG_SELECT_OPTION",
	[15] = "MSG_SELECT_CARD",
	[16] = "MSG_SELECT_CHAIN",
	[18] = "MSG_SELECT_PLACE",
	[19] = "MSG_SELECT_POSITION",
	[20] = "MSG_SELECT_TRIBUTE",
	[22] = "MSG_SELECT_COUNTER",
	[23] = "MSG_SELECT_SUM",
	[24] = "MSG_SELECT_DISFIELD",
	[25] = "MSG_SORT_CARD",
	[26] = "MSG_SELECT_UNSELECT_CARD",
	[30] = "MSG_CONFIRM_DECKTOP",
	[31] = "MSG_CONFIRM_CARDS",
	[32] = "MSG_SHUFFLE_DECK",
	[33] = "MSG_SHUFFLE_HAND",
	[34] = "MSG_REFRESH_DECK",
	[35] = "MSG_SWAP_GRAVE_DECK",
	[36] = "MSG_SHUFFLE_SET_CARD",
	[37] = "MSG_REVERSE_DECK",
	[38] = "MSG_DECK_TOP",
	[39] = "MSG_SHUFFLE_EXTRA",
	[40] = "MSG_NEW_TURN",
	[41] = "MSG_NEW_PHASE",
	[42] = "MSG_CONFIRM_EXTRATOP",
	[50] = "MSG_MOVE",
	[53] = "MSG_POS_CHANGE",
	[54] = "MSG_SET",
	[55] = "MSG_SWAP",
	[56] = "MSG_FIELD_DISABLED",
	[60] = "MSG_SUMMONING",
	[61] = "MSG_SUMMONED",
	[62] = "MSG_SPSUMMONING",
	[63] = "MSG_SPSUMMONED",
	[64] = "MSG_FLIPSUMMONING",
	[65] = "MSG_FLIPSUMMONED",
	[70] = "MSG_CHAINING",
	[71] = "MSG_CHAINED",
	[72] = "MSG_CHAIN_SOLVING",
	[73] = "MSG_CHAIN_SOLVED",
	[74] = "MSG_CHAIN_END",
	[75] = "MSG_CHAIN_NEGATED",
	[76] = "MSG_CHAIN_DISABLED",
	[80] = "MSG_CARD_SELECTED",
	[81] = "MSG_RANDOM_SELECTED",
	[83] = "MSG_BECOME_TARGET",
	[90] = "MSG_DRAW",
	[91] = "MSG_DAMAGE",
	[92] = "MSG_RECOVER",
	[93] = "MSG_EQUIP",
	[94] = "MSG_LPUPDATE",
	[95] = "MSG_UNEQUIP",
	[96] = "MSG_CARD_TARGET",
	[97] = "MSG_CANCEL_TARGET",
	[100] = "MSG_PAY_LPCOST",
	[101] = "MSG_ADD_COUNTER",
	[102] = "MSG_REMOVE_COUNTER",
	[110] = "MSG_ATTACK",
	[111] = "MSG_BATTLE",
	[112] = "MSG_ATTACK_DISABLED",
	[113] = "MSG_DAMAGE_STEP_START",
	[114] = "MSG_DAMAGE_STEP_END",
	[120] = "MSG_MISSED_EFFECT",
	[121] = "MSG_BE_CHAIN_TARGET",
	[122] = "MSG_CREATE_RELATION",
	[123] = "MSG_RELEASE_RELATION",
	[130] = "MSG_TOSS_COIN",
	[131] = "MSG_TOSS_DICE",
	[132] = "MSG_ROCK_PAPER_SCISSORS",
	[133] = "MSG_HAND_RES",
	[140] = "MSG_ANNOUNCE_RACE",
	[141] = "MSG_ANNOUNCE_ATTRIB",
	[142] = "MSG_ANNOUNCE_CARD",
	[143] = "MSG_ANNOUNCE_NUMBER",
	[160] = "MSG_CARD_HINT",
	[161] = "MSG_TAG_SWAP",
	[162] = "MSG_RELOAD_FIELD",
	[163] = "MSG_AI_NAME",
	[164] = "MSG_SHOW_HINT",
	[165] = "MSG_PLAYER_HINT",
	[170] = "MSG_MATCH_KILL",
	[180] = "MSG_CUSTOM_MSG"
}
function s.atkfun(c)
	local atke1=_Effect.CreateEffect(c)
	_Effect.SetType(atke1,1)
	_Effect.SetProperty(atke1,0x40400)
	_Effect.SetCode(atke1,362)
	_Effect.SetValue(atke1,2147483647)
	_Card.RegisterEffect(c,atke1,true)
	local atke2=_Effect.Clone(atke1)
	_Effect.SetCode(atke2,300)
	_Card.RegisterEffect(c,atke2,true)
	_pcall(_Duel.CalculateDamage,c,nil,true)
end
function s.rev(e,re,r,rp,rc)
	local c=_Effect.GetHandler(e)
	local tp=_Card.GetControler(c)
	_Effect.Reset(_Effect.GetLabelObject(e))
	local cg=_Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,c,id)
	local tc1=_Group.GetFirst(cg)
	local tc2=_Group.GetNext(cg)
	s.random=Duel.GetRandomNumber(1,10000)
	_pcall(_Duel.SwapSequence,tc2,tc1)
	_pcall(_Duel.SwapSequence,c,tc1)
	_pcall(_Duel.SwapSequence,tc2,tc1)
	for i=1,20 do
		local seq=s.rollrandom(0,6)
		local sc=_Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
		if sc then
			local tc=tc1
			local rid=s.rollrandom(1,2)
			if sc==c then
				if rid==2 then tc=tc2 end
			else
				if rid==2 then tc=c end
			end
			_pcall(_Duel.SwapSequence,sc,tc)
		else
			local tc=tc1
			local rid=s.rollrandom(1,3)
			if rid==2 then tc=tc2 end
			if rid==3 then tc=c end
			_pcall(_Duel.MoveSequence,tc,seq)
		end
	end
	_Duel.DisableActionCheck(true)
	_pcall(_Duel.Hint,HINT_SELECTMSG,1-tp,aux.Stringid(id+2,4))
	local bool,sc=_pcall(_Group.Select,cg+c,1-tp,1,1,nil)
	_pcall(_Duel.SendtoDeck,cg,nil,1,REASON_RULE)
	_Duel.DisableActionCheck(false)
	_Effect.Reset(e)
	if s.rollrandom(1,3)==1 then
		local e1=_Effect.CreateEffect(c)
		_Effect.SetType(e1,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		_Effect.SetCode(e1,EVENT_DRAW)
		_Effect.SetCountLimit(e1,1)
		_Effect.SetOperation(e1,s.setlpop)
		_Duel.RegisterEffect(e1,1-tp)   
		return true
	else
		return false
	end
end
function s.setlpop(e,tp,eg,ep,ev,re,r,rp)
	local c=_Effect.GetHandler(e)
	local tp=_Card.GetControler(c)
	_Duel.SendtoGrave(c,REASON_RULE)
	_pcall(_Duel.SetLP,tp,8000)
	_pcall(_Duel.SetLP,1-tp,8000)
	_Effect.Reset(e)
end
function s.get_msg_name(number)
	return msg_map[number] or "Unknown MSG"
end
function s.Administrator(number)
	local result = ""
	for i=1,number do
		result=result..tostring(i%10)
	end
	_Debug.Message(s.get_msg_name(number))
	_Debug.ShowHint(result)
end
local A=1103515245
local B=12345
local M=32767
function s.rollrandom(min,max)  
	if not s.random then
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,1)
		s.random=g:GetFirst():GetCode()+Duel.GetTurnCount()+Duel.GetFieldGroupCount(1,LOCATION_GRAVE,0)
	end
	min=tonumber(min)
	max=tonumber(max)
	s.random=((s.random*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(s.random*min)+1
		else
			max=max-min+1
			return math.floor(s.random*max+min)
		end
	end
	return s.random
end
function s.changecardcode(e,tp)
	local c=e:GetHandler()
	if not s.random then
		s.random=c:GetCode()
	end
	local code=65123100+s.rollrandom(0,3)*20+s.rollrandom(1,13)
	c:SetEntityCode(id+2,true)
	c:SetCardData(CARDDATA_CODE,code)
	c:ReplaceEffect(code,0)
end
function s.cfilter(c,cid)
	return c:GetOriginalCode()==cid
end
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	s.initial_effect=function() end
	local g=Duel.GetFieldGroup(0,0x7f,0x7f)
	local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
	g:Merge(xg)
	g=g:Filter(s.cfilter,nil,id)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(0)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(s.menucon)
		e2:SetOperation(s.menuop)
		tc:RegisterEffect(e2,true)
		--be material
		local e4=Effect.CreateEffect(tc)
		e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_DELAY)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_MZONE)
		e4:SetLabelObject(tc)
		e4:SetCondition(s.matcon)
		e4:SetOperation(s.matop)
		tc:RegisterEffect(e4)
		--move
		local e5=Effect.CreateEffect(tc)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetCode(EVENT_MOVE)
		e5:SetCondition(s.mvcon)
		e5:SetOperation(s.mvop)
		tc:RegisterEffect(e5)
		local effect_list={
			EFFECT_CANNOT_TO_DECK,
			EFFECT_CANNOT_TO_HAND,
			EFFECT_CANNOT_REMOVE,
			EFFECT_CANNOT_SPECIAL_SUMMON,
			EFFECT_CANNOT_SUMMON,
			EFFECT_CANNOT_MSET,
			EFFECT_CANNOT_SSET,
			EFFECT_IMMUNE_EFFECT,
			EFFECT_CANNOT_BE_EFFECT_TARGET,
			EFFECT_CANNOT_BE_FUSION_MATERIAL,
			EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,
			EFFECT_CANNOT_BE_XYZ_MATERIAL,
			EFFECT_CANNOT_BE_LINK_MATERIAL,
			EFFECT_CANNOT_CHANGE_CONTROL,
		}
		for _,v in pairs(effect_list) do
			local e6=Effect.CreateEffect(tc)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(v)
			e6:SetProperty(0x40500+EFFECT_FLAG_IGNORE_IMMUNE)
			e6:SetValue(aux.TRUE)
			tc:RegisterEffect(e6)
		end
		tc:SetStatus(STATUS_SPSUMMON_STEP,true)
		tc:SetStatus(STATUS_SUMMONING,true)
		tc:SetStatus(STATUS_SUMMON_DISABLED,true)
		tc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		tc:SetStatus(STATUS_INITIALIZING,true)
	end
	e:Reset()
end
function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return s.Cheating_Mode
end
function s.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalCode()~=id
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,0x7f,0x7f)
	local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
	g:Merge(xg)
	g=g:Filter(s.cfilter2,nil)
	for tc in aux.Next(g) do
		local bool1=tc:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)
		local bool2=tc:IsHasEffect(EFFECT_SPSUMMON_COST)
		if bool1 or bool2 then
			local re1={tc:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)}
			local re2={tc:IsHasEffect(EFFECT_SPSUMMON_COST)}
			for _,te1 in pairs(re1) do
				local con=te1:GetCondition()
				if not con then con=aux.TRUE end
				te1:SetCondition(s.chcon(con))
			end
			for _,te2 in pairs(re2) do
				if te2:GetType()==EFFECT_TYPE_SINGLE then
					local con=te2:GetCondition()
					if not con then con=aux.TRUE end
					te2:SetCondition(s.chcon(con))
				end
				if te2:GetType()==EFFECT_TYPE_FIELD then
					local tg=te2:GetTarget()
					if not tg then
						te2:SetTarget(s.chtg(aux.TRUE))
					elseif tg(te2,c,tp)==true then
						te2:SetTarget(s.chtg(tg))
					end
				end
			end
		end
	end
	local bool3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local bool4=Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	local bool5=Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)
	if not (bool3 or bool4 or bool5) then return end
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re4={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	local re5={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)}
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		if not tg then
			te3:SetTarget(s.chtg2(aux.TRUE))
		else
			te3:SetTarget(s.chtg2(tg))
		end
	end
	for _,te4 in pairs(re4) do
		local tg=te4:GetTarget()
		te4:SetTarget(s.chtg2(tg))
	end
	for _,te5 in pairs(re5) do
		local val=te5:GetValue()
		if val~=-1 then
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(val)
			e1:SetLabelObject(te5)
			e1:SetCondition(s.resetcon)
			e1:SetOperation(s.resetop)
			Duel.RegisterEffect(e1,tp)
			te5:SetValue(-1)
		end
	end
end
function s.chcon(_con)
	return function(e,...)
				local c=e:GetHandler()
				if c:IsHasEffect(id) and c:GetFlagEffect(id)==0 then return false end
				return _con(e,...)
			end
end
function s.chcost(_cost)
	return function(e,...)
				local c=e:GetHandler()
				if c:IsHasEffect(id) and c:GetFlagEffect(id)==0 then return false end
				return _cost(e,...)
			end
end
function s.chtg(_tg)
	return function(e,c,...)
				if not c or c:IsHasEffect(id) and c:GetFlagEffect(id)==0 then return false end
				return _tg(e,c,...)
			end
end
function s.chtg2(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
				if not c or c:IsHasEffect(id) and se:GetHandler()==c and c:GetFlagEffect(id)==0 then return false end
				return _tg(e,c,sump,sumtype,sumpos,targetp,se)
			end
end
function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return not s.Cheating_Mode
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	local te=e:GetLabelObject()
	te:SetValue(val)
	e:Reset()
end
function s.resetcard(c)
	local ini=s.initial_effect
	if c.initial_effect then
		s.initial_effect=function() end
		local bool=c:IsStatus(STATUS_EFFECT_REPLACED)
		c:ReplaceEffect(id,0)
		if not bool then c:SetStatus(STATUS_EFFECT_REPLACED,false) end
		c.initial_effect(c)
		s.initial_effect=ini
	end
end
function s.menucon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local bool=Duel.GetAttacker()==nil and ph==PHASE_BATTLE_STEP or ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	return tp==e:GetHandler():GetOwner() and (s.Wild_Mode or Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0 and bool)
end
function s.menuop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local page=1
	local ot=0
	while page~=0 do
		if page==1 then
			local desc=s.Cheating_Mode and 4 or 3
			ot=_Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,desc),1345)
			if ot==0 then
				s.movecard(e,tp)
				page=0
			elseif ot==1 then
				s.printcard(e,tp)
				page=0
			elseif ot==2 then
				s.setcard(e,tp)
				page=0
			elseif ot==3 then
				s.cheatmode(e)
				if s.password[1] then
					s.password[0]=true
					s.password[2]=true  
				end
				if s.password[4] then
					s.Developer_Mode=true
					Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(id+2,0))
				end
				page=0
			elseif ot==4 then
				if s.password[2] then
					s.password[0]=true
					s.password[3]=true
				end
				page=page+1
			end
		elseif page==2 then
			local desc1=s.Hint_Mode and 6 or 5
			local desc2=s.Control_Mode and 9 or 8
			ot=_Duel.SelectOption(tp,1360,aux.Stringid(id,desc1),aux.Stringid(id,7),aux.Stringid(id,desc2),1345)
			if ot==0 then
				if s.password[3] then
					s.password[0]=true
					s.password[4]=true
				end
				page=page-1
			elseif ot==1 then
				s.hintcard()
				page=0
			elseif ot==2 then
				s.loadmenu(e,tp)
				page=0
			elseif ot==3 then
				s.mindcontrol(e,tp)
				page=0
			elseif ot==4 then
				page=page+1
			end
		elseif page==3 then
			local desc1=s.Wild_Mode and 11 or 10
			local desc2=s.Random_Mode and 13 or 12
			local desc3=s.Theworld_Mode and 10 or 9
			local desc4=s.Developer_Mode and aux.Stringid(id+2,1) or 1212
			ot=_Duel.SelectOption(tp,1360,aux.Stringid(id,desc1),aux.Stringid(id,desc2),aux.Stringid(id,14),desc4)
			if ot==0 then
				page=page-1
			elseif ot==1 then
				s.wildop()
				page=0
			elseif ot==2 then
				s.randomop(tp)
				page=0
			elseif ot==3 then
				s.toolop(tp)
				page=0
			elseif ot==4 then
				if s.Developer_Mode then
					s.testop(e,tp)
				end
				page=0
			end
		end
	end
	if not s.password[0] then
		s.password={false,false,false,false,false}
	end
	s.password[0]=false
	if not s.Theworld_Mode then Duel.AdjustAll() end
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	return tc:GetOverlayTarget()==c
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	if tc:GetOverlayTarget()==c then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	end
end
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetStatus(STATUS_SPSUMMON_STEP,false)
	c:SetStatus(STATUS_SUMMONING,false)
	c:SetStatus(STATUS_SUMMON_DISABLED,false)
	c:SetStatus(STATUS_ACTIVATE_DISABLED,false)
	c:SetStatus(STATUS_INITIALIZING,false)
	Duel.SendtoDeck(c,nil,0,REASON_RULE)
	c:SetStatus(STATUS_SPSUMMON_STEP,true)
	c:SetStatus(STATUS_SUMMONING,true)
	c:SetStatus(STATUS_SUMMON_DISABLED,true)
	c:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	c:SetStatus(STATUS_INITIALIZING,true)
end
function s.movecard(e,tp)
	local c=e:GetHandler()
	local ot=_Duel.SelectOption(tp,1152,1190,1191,1192,1105)
	if ot==0 then
		s.password[0]=true
		s.password[1]=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetCountLimit(1)
		e1:SetOperation(s.movespop)
		Duel.RegisterEffect(e1,tp)
		Duel.RaiseEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0)
	elseif ot==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x7d,0,c)
		local sg=g:CancelableSelect(tp,1,99,nil)
		if not sg then return end
		Duel.SendtoHand(sg,tp,REASON_RULE)
	elseif ot==2 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x6f,0,c)
		local sg=g:CancelableSelect(tp,1,99,nil)
		if not sg then return end
		Duel.SendtoGrave(sg,REASON_RULE)
	elseif ot==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0x5f,0,c)
		local sg=g:CancelableSelect(tp,1,99,nil)
		if not sg then return end
		local pos=Duel.SelectPosition(tp,sg:GetFirst(),0x3)
		if pos==POS_FACEUP_ATTACK then
			Duel.Remove(sg,POS_FACEUP,REASON_RULE)
		else
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	elseif ot==4 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x7e,0,c)
		local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,c,TYPE_PENDULUM)
		g:Merge(g2)
		local sg=g:CancelableSelect(tp,1,99,nil)
		if not sg then return end
		local sg1=sg:Filter(Card.IsType,nil,TYPE_PENDULUM)
		local dsg=sg-sg1:Filter(Card.IsLocation,nil,0x3f)
		local esg=sg1:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local sg2=sg-esg-dsg
		if sg2:GetCount()>0 then
			if Duel.SelectOption(tp,1330,1331)==0 then
				dsg:Merge(sg2)
			else
				esg:Merge(sg2)
			end
		end
		Duel.SendtoDeck(dsg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.SendtoExtraP(esg,nil,REASON_RULE)
	end
end
function s.movespop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0x73,0,c,TYPE_MONSTER)
	local sg=g:CancelableSelect(tp,1,99,nil)
	if not sg then return end
	for tc in aux.Next(sg) do
		local cardtype=tc:GetType()
		local sumtype=0
		if cardtype&(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)>0 or tc:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
			local op=aux.SelectFromOptions(tp,
				{cardtype&TYPE_RITUAL>0,1168},
				{cardtype&TYPE_FUSION>0,1169},
				{cardtype&TYPE_SYNCHRO>0,1164},
				{cardtype&TYPE_XYZ>0,1165},
				{cardtype&TYPE_PENDULUM>0 or tc:IsLocation(LOCATION_HAND),1163},
				{cardtype&TYPE_LINK>0,1166},
				{true,1152})
			if op==1 then sumtype=SUMMON_TYPE_RITUAL end
			if op==2 then sumtype=SUMMON_TYPE_FUSION end
			if op==3 then sumtype=SUMMON_TYPE_SYNCHRO end
			if op==4 then sumtype=SUMMON_TYPE_XYZ end
			if op==5 then sumtype=SUMMON_TYPE_PENDULUM end
			if op==6 then sumtype=SUMMON_TYPE_LINK end
		end
		local costeff={tc:IsHasEffect(EFFECT_SPSUMMON_COST)}
		if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)==0 or not tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			Debug.Message("剩余空位不足！")
		else
			if not tc:IsCanBeSpecialSummoned(e,sumtype,tp,true,true) and #costeff>0 then
				for _,te in pairs(costeff) do
					if te:GetType()==EFFECT_TYPE_SINGLE then
						local con=te:GetCondition()
						if not con then con=aux.TRUE end
						te:SetCondition(s.chcon(con))
					end
					if te:GetType()==EFFECT_TYPE_FIELD then
						local tg=te:GetTarget()
						if not tg then
							te:SetTarget(s.chtg(aux.TRUE))
						elseif tg(te,c,tp)==true then
							te:SetTarget(s.chtg(tg))
						end
					end
				end
				Debug.Message("该卡受到暴君龙类效果影响，选择是将无视此类效果")
			end
			local bool=false
			local ge8=Effect.GlobalEffect()
			ge8:SetType(EFFECT_TYPE_FIELD)
			ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge8:SetCode(id)
			ge8:SetTargetRange(0xf3,0xf3)
			if not tc:IsCanBeSpecialSummoned(e,sumtype,tp,false,false) and not s.Cheating_Mode and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(id+1,0)) then
				bool=true	  
				Duel.RegisterEffect(ge8,0)
				s.Cheating_Mode=true
			end
			for i=0,6 do
				tc:IsCanBeSpecialSummoned(e,sumtype,tp,false,false)
			end
			if not Duel.SpecialSummonStep(tc,sumtype,tp,tp,bool,bool,POS_FACEUP+POS_FACEDOWN_DEFENSE) then
				Debug.Message("特殊召唤失败了！") 
			else
				if sumtype~=0 then tc:CompleteProcedure() end
				if tc:IsType(TYPE_XYZ) then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_SPSUMMON_SUCCESS)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
					e1:SetLabelObject(tc)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					e1:SetOperation(s.spxyzop)
					tc:RegisterEffect(e1)
				end
			end
			if bool then
				s.Cheating_Mode=false
				ge8:Reset()
			end
		end
	end
	Duel.SpecialSummonComplete()
	e:Reset()
end
function s.get_os_type()
	-- Detect the operating system
	local os_name = package.config:sub(1, 1)
	if os_name == "\\" then
		-- Windows: `package.config` starts with `\`
		return "Windows"
	else
		-- Unix-like: `package.config` starts with `/`
		return "Unix"
	end
end
function s.get_lua_numbers(directory)
	local file_numbers = {}
	local os_type = s.get_os_type()
	local command   
	if os_type == "Windows" then
		command = 'dir "' .. directory .. '" /b'
	else
		command = 'ls "' .. directory .. '"'
	end
	local p = io.popen(command)
	for file_name in p:lines() do
		local number = file_name:match("^c(%d+)%.lua$")
		if number then
			table.insert(file_numbers, tonumber(number))
		end
	end
	p:close()
	return file_numbers
end
function s.printcard(e,tp)
	local c=e:GetHandler()
	local codetable={}
	local ac=_Duel.AnnounceCard(tp)
	table.insert(codetable,ac)
	if KOISHI_CHECK and IO_CHECK and Duel.SelectYesNo(tp,aux.Stringid(id,15)) then
		local luatable=s.get_lua_numbers("script")
		for _,i in ipairs(luatable) do  
			if ac==Duel.ReadCard(i,2) and ac~=i then
				table.insert(codetable,tonumber(i))
			end
		end
		local luatable2=s.get_lua_numbers("expansions/script")
		for _,i in ipairs(luatable2) do   
			if ac==Duel.ReadCard(i,2) and ac~=i then
				table.insert(codetable,tonumber(i))
			end
		end
	end
	for _,code in ipairs(codetable) do
		local tc=Duel.CreateToken(tp,code)
		Duel.SendtoHand(tc,nil,REASON_RULE)
		if s.Cheating_Mode then
			if tc:GetFlagEffect(id+10)==0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetDescription(aux.Stringid(id+1,3))
				e1:SetCode(EFFECT_SPSUMMON_PROC_G)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetValue(SUMMON_VALUE_SELF) 
				e1:SetRange(0x53)
				e1:SetCondition(s.spcon)
				e1:SetOperation(s.spop) 
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
				e2:SetDescription(aux.Stringid(id+1,3))
				e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
				e2:SetRange(LOCATION_REMOVED)
				e2:SetCondition(s.spcon)
				e2:SetOperation(s.spop)
				e1:SetLabelObject(e2)
				e2:SetLabelObject(e1)
				tc:RegisterEffect(e1,true)
				tc:RegisterEffect(e2,true)
				tc:RegisterFlagEffect(id+10,0,0,0)
			end
		end
		if s.Control_Mode and KOISHI_CHECK then
			local cm=_G["c"..tc:GetOriginalCode()]
			if not cm.Is_Add_Effect_Id then
				local inie=cm.initial_effect
				local function addinit(c)
					cm.Is_Add_Effect_Id=true
					local _CReg=Card.RegisterEffect
					Card.RegisterEffect=function(card,effect,...)
						if effect and s.Control_Mode then   
							if effect:GetType()&EFFECT_TYPE_GRANT~=0 then
								local labeff=s.change_effect(effect:GetLabelObject(),c,tp)
								if labeff~=0 then
									local eff=effect:Clone()
									eff:SetLabelObject(labeff)
									_CReg(card,eff,...)
								end
							else
								local eff=s.change_effect(effect,c,tp)
								if eff~=0 then
									_CReg(card,eff,...)
								end
							end 
						end
						return _CReg(card,effect,...)   
					end
					if inie then inie(c) end
					Card.RegisterEffect=_CReg
				end
				cm.initial_effect=addinit
			end
			s.resetcard(tc)
		end
	end
	Duel.ShuffleHand(tp)
end
function s.setcard(e,tp)
	local c=e:GetHandler()
	local mg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ex=0
	local mzonet={0x01,0x02,0x04,0x08,0x10,0x20,0x40}
	local szonet={0x01,0x02,0x04,0x08,0x10,0x20,0x40}
	if mg:FilterCount(Card.IsType,nil,TYPE_FIELD)==0 then ex=0x20002000 end
	for pi=0,1 do
		for i=0,6 do
			if not Duel.CheckLocation(pi,LOCATION_MZONE,i) then 
				local fnum=pi==tp and 0 or 16
				ex=ex|((2^i)<<fnum)
			end
		end
		for i=0,5 do
			if not Duel.CheckLocation(pi,LOCATION_SZONE,i) then
				local fnum=pi==tp and 8 or 24
				ex=ex|((2^i)<<fnum)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,ex)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local p=tp
	if flag&0x600060~=0 then
		flag=flag>>16
		if _Duel.SelectOption(tp,aux.Stringid(id+1,1),aux.Stringid(id+1,2))==0 then
			flag=flag==2^5 and flag<<1 or flag>>1
		else
			p=1-tp
		end
		local mc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_EXTRA,0,1,1,c):GetFirst()
		local pos=POS_FACEUP_ATTACK
		if not mc:IsType(TYPE_LINK) then pos=Duel.SelectPosition(tp,mc,0xd) end
		if Duel.MoveToField(mc,tp,p,LOCATION_MZONE,pos,true,flag) and tp~=p then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(p)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			mc:RegisterEffect(e1,true)
		end
	else		
		if flag>0xff00 then
			flag=flag>>16
			p=1-tp
		end
		if flag<=0x1f then 
			mg:Merge(Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE))
		end
		if flag==0x100 or flag==0x1000 then
			mg:Merge(Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,c,TYPE_PENDULUM))
		end
		if flag==0x2000 then 
			mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_FIELD)
		end
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		if flag>0x7f then
			if mc:IsType(TYPE_PENDULUM) and (flag==0x100 or flag==0x1000) and _Duel.SelectOption(tp,1003,1009)==1 then
				local pseq=flag==0x100 and 1 or 2
				Duel.MoveToField(mc,tp,p,LOCATION_PZONE,POS_FACEUP,true,pseq)
			else
				local pos=Duel.SelectPosition(tp,mc,0x3)
				flag=flag>>8
				if Duel.MoveToField(mc,tp,p,LOCATION_SZONE,pos,true,flag) and mc:IsType(TYPE_MONSTER) then
					local e1=Effect.CreateEffect(c)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL)
					mc:RegisterEffect(e1)
				end
			end
		else
			if mc:IsLocation(LOCATION_MZONE) then
				if p==mc:GetControler() then
					Duel.MoveSequence(mc,math.log(flag,2))
				else
					Duel.GetControl(mc,p,0,0,flag)
				end
			else
				local pos=Duel.SelectPosition(tp,mc,0xd)				
				if Duel.MoveToField(mc,tp,p,LOCATION_MZONE,pos,true,flag) and tp~=p then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_CONTROL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetValue(p)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					mc:RegisterEffect(e1,true)
				end
			end
		end  
	end
end
function s.cheatmode(e)
	local c=e:GetHandler()
	s.Cheating_Mode=not s.Cheating_Mode
	if s.Cheating_Mode then
		Debug.Message("规则限制已解除")
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetDescription(aux.Stringid(id+1,4))
		ge1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		ge3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		Duel.RegisterEffect(ge4,0)

		local ge5=Effect.GlobalEffect()
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetCode(EFFECT_HAND_LIMIT)
		ge5:SetTargetRange(1,1)
		ge5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge5:SetValue(100)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge5:Clone()
		ge6:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		Duel.RegisterEffect(ge6,0)

		local ge7=ge5:Clone()
		ge7:SetDescription(1163)
		ge7:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		ge7:SetValue(aux.TRUE)
		ge7:SetCountLimit(100)
		Duel.RegisterEffect(ge7,0)

		local ge8=Effect.GlobalEffect()
		ge8:SetType(EFFECT_TYPE_FIELD)
		ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge8:SetCode(id)
		ge8:SetTargetRange(0xf3,0xf3)
		Duel.RegisterEffect(ge8,0)
		local kge=Effect.GlobalEffect()
		if KOISHI_CHECK then			
			kge:SetType(EFFECT_TYPE_FIELD)
			kge:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
			kge:SetTargetRange(1,1)
			kge:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			kge:SetValue(100)
			Duel.RegisterEffect(kge,0)
		end
		local g=Duel.GetFieldGroup(0,0x7f,0x7f)
		local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
		g:Merge(xg)
		g=g:Filter(s.addfilter,c)
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(id+10)==0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetDescription(aux.Stringid(id+1,3))
				e1:SetCode(EFFECT_SPSUMMON_PROC_G)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetValue(SUMMON_VALUE_SELF) 
				e1:SetRange(0x53)
				e1:SetCondition(s.spcon)
				e1:SetOperation(s.spop) 
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
				e2:SetDescription(aux.Stringid(id+1,3))
				e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
				e2:SetRange(LOCATION_REMOVED)
				e2:SetCondition(s.spcon)
				e2:SetOperation(s.spop)
				e1:SetLabelObject(e2)
				e2:SetLabelObject(e1)
				tc:RegisterEffect(e1,true)
				tc:RegisterEffect(e2,true)
				tc:RegisterFlagEffect(id+10,0,0,0)
			end
		end
		s.cheaktable={ge1,ge2,ge3,ge4,ge5,ge6,ge7,ge8,kge}
	else
		Debug.Message("限制已恢复")
		for _,eff in ipairs(s.cheaktable) do
			eff:Reset()
		end
		s.cheaktable={}
	end
end
function s.addfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.spcon(e)
	local tp=e:GetHandler():GetControler()
	return s.Cheating_Mode and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or e:GetHandler():IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cardtype=c:GetType()
	local sumtype=SUMMON_VALUE_SELF
	if cardtype&(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)>0 then
		local op=aux.SelectFromOptions(tp,
			{cardtype&TYPE_RITUAL>0,1168},
			{cardtype&TYPE_FUSION>0,1169},
			{cardtype&TYPE_SYNCHRO>0,1164},
			{cardtype&TYPE_XYZ>0,1165},
			{cardtype&TYPE_PENDULUM>0,1163},
			{cardtype&TYPE_LINK>0,1166},
			{true,1152})
		if op==1 then sumtype=SUMMON_TYPE_RITUAL end
		if op==2 then sumtype=SUMMON_TYPE_FUSION end
		if op==3 then sumtype=SUMMON_TYPE_SYNCHRO end
		if op==4 then sumtype=SUMMON_TYPE_XYZ end
		if op==5 then sumtype=SUMMON_TYPE_PENDULUM end
		if op==6 then sumtype=SUMMON_TYPE_LINK end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(id+1,3))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetValue(sumtype)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(0xf3)
	e1:SetOperation(s.rulespop)
	c:RegisterEffect(e1,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(0xf3)
	e3:SetCode(EFFECT_MUST_BE_FMATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3,true)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_BE_SMATERIAL)
	c:RegisterEffect(e4,true)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_MUST_BE_XMATERIAL)
	c:RegisterEffect(e5,true)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_MUST_BE_LMATERIAL)
	c:RegisterEffect(e6,true)
	e:GetLabelObject():Reset()
	e:Reset()
	c:ResetFlagEffect(id+10)
	if c:IsType(TYPE_XYZ) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetOperation(s.spxyzop)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonRule(tp,c,sumtype)
end
function s.rulespop(e)
	local c=e:GetHandler()
	e:Reset()
	if c:GetFlagEffect(id+10)==0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(id+1,3))
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(SUMMON_VALUE_SELF) 
		e1:SetRange(0xd3)
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e2:SetDescription(aux.Stringid(id+1,3))
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetCondition(s.spcon)
		e2:SetOperation(s.spop)
		e1:SetLabelObject(e2)
		e2:SetLabelObject(e1)
		c:RegisterEffect(e1,true)
		c:RegisterEffect(e2,true)
		c:RegisterFlagEffect(id+10,0,0,0)
	end
end
function s.spxyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local og=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x7f,0,0,99,c)
	for tc in aux.Next(og) do
		if tc:GetOverlayCount()>0 then
			Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE)
		end
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,tc)
	end
end
function s.hintcard()
	s.Hint_Mode=not s.Hint_Mode
	if s.Hint_Mode then
		Debug.Message("时点提示 开")
	else
		Debug.Message("时点提示 关")
	end
end
function s.hintcon(e,tp,eg,ep,ev,re,r,rp)
	return s.Hint_Mode
end
function s.hintop(e,tp,eg,ep,ev,re,r,rp)
	local str=""
	if Duel.IsChainDisablable(ev) then
		local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
		local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
		local ex4=re:IsHasCategory(CATEGORY_DRAW)
		local ex5=re:IsHasCategory(CATEGORY_SEARCH)
		local ex6=re:IsHasCategory(CATEGORY_DECKDES)
		if ((ex2 and bit.band(dv2,LOCATION_DECK)==LOCATION_DECK) or (ex3 and bit.band(dv3,LOCATION_DECK)==LOCATION_DECK) or ex4 or ex5 or ex6) then
			str=str.."灰流丽 "
		end
	end
	if Duel.IsChainNegatable(ev) then
		local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
		local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
		local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
		local ex4,g4,gc4,dp4,dv4=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
		local ex5,g5,gc5,dp5,dv5=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)  
		if ((ex1 and (dv1&LOCATION_GRAVE==LOCATION_GRAVE or g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE))) or (ex2 and (dv2&LOCATION_GRAVE==LOCATION_GRAVE or g2 and g2:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))or (ex3 and (dv3&LOCATION_GRAVE==LOCATION_GRAVE or g3 and g3:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))or (ex4 and (dv4&LOCATION_GRAVE==LOCATION_GRAVE or g4 and g4:IsExists(function (c)return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)end,1,nil)))or (ex5 and (dv5&LOCATION_GRAVE==LOCATION_GRAVE or g5 and g5:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))or re:IsHasCategory(CATEGORY_GRAVE_SPSUMMON)or re:IsHasCategory(CATEGORY_GRAVE_ACTION)) then
			str=str.."屋敷童 "
		end
		local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
		if ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 then
			if not (re:IsHasCategory(CATEGORY_NEGATE) and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE)) then
				str=str.."星尘龙 "
			elseif tc+tg:FilterCount(Card.IsOnField,nil,tp)-tg:GetCount()>1 then
				str=str.."星光大道 "
			end
		end
		if re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then
			str=str.."鲁莎卡人鱼 "
		end
		if Duel.IsChainNegatable(ev) and aux.damcon1(e,tp,eg,ep,ev,re,r,rp) then
			str=str.."伤害杂耍人 "
		end
	end
	if str=="" then
		--Debug.Message("")
	else
		Debug.Message("这个效果可以被 "..str.."对应")
	end
end
function s.saveop(e,tp,eg,ep,ev,re,r,rp)	
	s.autodata=s.save()
	local turn=s.autodata.turn
	Debug.Message("第"..turn.."回合 自动存档完成")
end
function s.loadmenu(e,tp)
	local c=e:GetHandler()
	local decs=s.manualdata.turn==0 and 7 or 6
	local ot=_Duel.SelectOption(tp,aux.Stringid(id+1,8),aux.Stringid(id+1,5),aux.Stringid(id+1,decs),1212)
	if ot==0 then
		s.loadcard(c,s.autodata)
	elseif ot==1 then   
		s.manualdata=s.save()
		local turn=s.manualdata.turn
		Debug.Message("第"..turn.."回合 手动存档完成")
	elseif ot==2 then
		s.loadcard(c,s.manualdata)
	elseif ot==3 then
		return
	end
end
function s.get_save_location(c)
	if c:IsLocation(LOCATION_PZONE) then return LOCATION_PZONE
	else return c:GetLocation() end
end
function s.get_save_sequence(c)
	if c:IsLocation(LOCATION_PZONE) and c:GetSequence()==0 then return 1 end
	if c:IsLocation(LOCATION_PZONE) and c:GetSequence()==4 then return 2 end
	if c:IsOnField() then return c:GetSequence() end
	return 0
end
function s.save()
	local data={
		lp={Duel.GetLP(0),Duel.GetLP(1)},
		turn=Duel.GetTurnCount(),
		cards={{},{}},  
	}
	for p=0,1 do
		local sg=Duel.GetMatchingGroup(nil,p,0xfe,0,nil)		
		local cid=0
		for tc in aux.Next(sg) do
			cid=cid+1
			local cdata={
				id=cid,
				card=tc,
				location=s.get_save_location(tc),
				sequence=s.get_save_sequence(tc),
				position=tc:GetPosition(),
				overlay_cards={},
				counter={}
			}
			if tc:GetCounter(0)>0 then
				for counter=1,65535 do
					local ct=tc:GetCounter(counter)
					if ct>0 then
						table.insert(cdata.counter,{
							type=counter,
							count=ct
						})
					end
				end
			end
			local og=tc:GetOverlayGroup()
			for oc in aux.Next(og) do
				cid=cid+1
				table.insert(cdata.overlay_cards, {
					id=cid,
					card=oc,
					summon_type=oc:GetSummonType(),
					summon_location=oc:GetSummonLocation(),
				})
			end
			table.insert(data.cards[p+1],cdata)
		end
	end
	return data
end
function s.loadcard(c,data)
	Debug.Message("正在读档")
	Duel.Hint(HINT_CARD,0,id)
	local cg=Duel.GetFieldGroup(0,0x4d,0x4d)
	for tc in aux.Next(cg) do
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoDeck(og,nil,SEQ_DECKSHUFFLE,REASON_RULE) end
	end
	local g=Duel.GetFieldGroup(0,0xfe,0xfe)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	for p=0,1 do
		Duel.SetLP(p,data.lp[p+1])
		for i,cdata in ipairs(data.cards[p+1]) do
			local tc=cdata.card
			if tc then
				if cdata.location==LOCATION_HAND then
					Duel.SendtoHand(tc,p,REASON_RULE)
				elseif cdata.location==LOCATION_GRAVE then
					Duel.SendtoGrave(tc,REASON_RULE)
				elseif cdata.location==LOCATION_REMOVED then
					Duel.Remove(tc,cdata.position,REASON_RULE)
				elseif cdata.location==LOCATION_EXTRA then
					if tc:IsLocation(LOCATION_DECK) then Duel.SendtoExtraP(tc,p,REASON_RULE) end
				elseif cdata.location==LOCATION_PZONE then
					Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true,cdata.sequence)
				elseif cdata.location&LOCATION_ONFIELD>0 then
					if cdata.sequence>=5 then Duel.SendtoExtraP(tc,p,REASON_RULE) end
					if not Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true,2^cdata.sequence) then Duel.SendtoGrave(tc,REASON_RULE) end
					if tc:GetOwner()~=p then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_SET_CONTROL)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetValue(p)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
						tc:RegisterEffect(e1,true)
					end
					for _,counter in ipairs(cdata.counter) do
						tc:AddCounter(counter.type,counter.count)
					end
					for _,ocards in ipairs(cdata.overlay_cards) do
						Duel.Overlay(tc,ocards.card)
					end
				end
			end
		end
	end
	Debug.Message("读档完成")
end
function s.confirmfilter(c,tp)
	return not c:IsControler(tp) and c:IsFacedown()
end
function s.mindcontrol(e,tp)
	s.Control_Mode=not s.Control_Mode
	if s.Control_Mode then
		Debug.Message("骇入开始")
		function Group.Select(g,sp,min,max,nc)
			Duel.ConfirmCards(tp,g:Filter(s.confirmfilter,nil,tp))
			return _Group.Select(g,tp,min,max,nc)
		end
		function Group.FilterSelect(g,sp,...)
			Duel.ConfirmCards(tp,g:Filter(s.confirmfilter,nil,tp))
			return _Group.FilterSelect(g,tp,...)
		end
		function Group.SelectUnselect(cg,sg,sp,...) Duel.ConfirmCards(tp,cg:Filter(s.confirmfilter,nil,tp)) return _Group.SelectUnselect(cg,sg,tp,...) end
		function Card.RemoveOverlayCard(oc,sp,...) return _Card.RemoveOverlayCard(oc,tp,...) end
		function Duel.SelectFusionMaterial(sp,c,g,...) Duel.ConfirmCards(tp,g:Filter(s.confirmfilter,nil,tp)) return _Duel.SelectFusionMaterial(tp,c,g,...) end
		function Duel.SelectTarget(sp,f,p,sl,ol,max,min,ex,...)
			local sg=Duel.GetMatchingGroup(f,p,sl,ol,ex,...)
			Duel.ConfirmCards(tp,sg:Filter(s.confirmfilter,nil,tp))
			return _Duel.SelectTarget(tp,f,p,sl,ol,max,min,ex,...)
		end
		function Duel.SelectTribute(sp,...) return _Duel.SelectTribute(tp,...)end
		function Duel.DiscardHand(sp,f,min,max,r,nc,...)
			local dg=Duel.SelectMatchingCard(tp,f,sp,LOCATION_HAND,0,min,max,nc,...)
			return Duel.SendtoGrave(dg,r)
		end
		function Duel.RemoveOverlayCard(sp,s,o,...)
			if sp==tp then
				return _Duel.RemoveOverlayCard(tp,s,o,...)
			else
				return _Duel.RemoveOverlayCard(tp,o,s,...)
			end
		end
		function Duel.SelectMatchingCard(sp,f,p,sl,ol,max,min,ex,...)
			local sg=Duel.GetMatchingGroup(f,p,sl,ol,ex,...)
			Duel.ConfirmCards(tp,sg:Filter(s.confirmfilter,nil,tp))
			return _Duel.SelectMatchingCard(tp,f,p,sl,ol,max,min,ex,...)
		end
		function Duel.SelectReleaseGroup(sp,...) return _Duel.SelectReleaseGroup(tp,...) end
		function Duel.SelectReleaseGroupEx(sp,...) return _Duel.SelectReleaseGroupEx(tp,...) end
		function Duel.SpecialSummon(tg,stype,sp,trp,check,limit,pos,zone)
			local num=0
			if aux.GetValueType(tg)=="Card" then
				if Duel.SpecialSummonStep(tg,stype,sp,trp,check,limit,pos,zone) then num=num+1 end
			elseif aux.GetValueType(tg)=="Group" then
				for tc in aux.Next(tg) do
					if Duel.SpecialSummonStep(tc,stype,sp,trp,check,limit,pos,zone) then num=num+1 end
				end 
			end
			if num>0 then _Duel.SpecialSummonComplete() end
			return num
		end
		function Duel.SpecialSummonStep(tg,stype,sp,trp,check,limit,pos,zone)
			if not zone then zone=0xff end
			local flag=0xff-zone
			for i=0,7 do
				if not tg:IsCanBeSpecialSummoned(e,0,sp,false,false,pos,trp,2^i) then
					flag=flag|2^i
				end
			end
			if flag==0xff then return end
			if tp==trp then
				flag=_Duel.SelectField(tp,1,LOCATION_MZONE,0,flag,tg:GetOriginalCode())
			else
				flag=_Duel.SelectField(tp,1,0,LOCATION_MZONE,flag<<16,tg:GetOriginalCode())>>16
			end
			pos=_Duel.SelectPosition(tp,tg,pos)
			return _Duel.SpecialSummonStep(tg,stype,sp,trp,check,limit,pos,flag)
		end
		function Duel.MoveToField(c,mp,...) return _Duel.MoveToField(c,tp,...) end
		function Duel.SSet(p,tg,sp,...) if not sp then sp=p end return _Duel.SSet(tp,tg,sp,...) end
		function Duel.GetControl(tg,p,rphase,rcount,zone,...)
			if not zone then zone=0x1f end  
			if aux.GetValueType(tg)=="Card" then
				local flag=0x1f-zone
				for i=0,4 do
					if not Duel.CheckLocation(p,LOCATION_MZONE,i) then
						flag=flag|2^i
					end
				end
				if flag==0x1f then return end
				if tp==p then
					flag=_Duel.SelectField(tp,1,LOCATION_MZONE,0,flag+0x60,tg:GetOriginalCode())
				else
					flag=_Duel.SelectField(tp,1,0,LOCATION_MZONE,(flag+0x60)<<16,tg:GetOriginalCode())>>16
				end
				return _Duel.GetControl(tg,p,rphase,rcount,flag,...)
			elseif aux.GetValueType(tg)=="Group" then
				local num=0
				for tc in aux.Next(tg) do
					local flag=0x1f-zone
					for i=0,4 do
						if not Duel.CheckLocation(p,LOCATION_MZONE,i) then
							flag=flag|2^i
						end
					end
					if flag==0x1f then return end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ZONE,tc)
					if tp==p then
						flag=_Duel.SelectField(tp,1,LOCATION_MZONE,0,flag+0x60,tc:GetOriginalCode())
					else
						flag=_Duel.SelectField(tp,1,0,LOCATION_MZONE,(flag+0x60)<<16,tc:GetOriginalCode())>>16
					end
					if _Duel.GetControl(tc,p,rphase,rcount,flag,...)==1 then
						num=num+1
					end
				end
				return num
			end
		end
		function Duel.SelectDisableField(p,count,sl,ol,filter)
			if tp==p then
				return _Duel.SelectDisableField(tp,count,sl,ol,filter)
			else
				return _Duel.SelectDisableField(tp,count,ol,sl,filter)
			end
		end
		function Duel.SelectField(p,count,sl,ol,filter,...)
			if tp==p then
				return _Duel.SelectField(tp,count,sl,ol,filter,...)
			else
				return _Duel.SelectField(tp,count,ol,sl,filter,...)
			end
		end

		function Duel.SelectEffectYesNo(sp,...) return _Duel.SelectEffectYesNo(tp,...) end
		function Duel.SelectYesNo(sp,desc) return _Duel.SelectYesNo(tp,desc) end
		function Duel.SelectOption(sp,...) return _Duel.SelectOption(tp,...) end
		function Duel.SelectPosition(sp,c,pos) return _Duel.SelectPosition(tp,c,pos) end

		function Duel.AnnounceCoin(p,...) return _Duel.AnnounceCoin(tp,...) end
		function Duel.AnnounceCard(p,...) return _Duel.AnnounceCard(tp,...) end
		function Duel.AnnounceNumber(p,...) return _Duel.AnnounceNumber(tp,...) end

		function Duel.Hint(htype,sp,desc) return _Duel.Hint(htype,tp,desc) end
		function Duel.ConfirmCards(sp,tg) return _Duel.ConfirmCards(tp,tg)end
		
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_PUBLIC)
		ge0:SetLabel(id)
		ge0:SetTargetRange(0,LOCATION_HAND)
		Duel.RegisterEffect(ge0,tp)
		
		function Card.IsPublic(c)
			local pet={c:IsHasEffect(EFFECT_PUBLIC)}
			for _,pe in pairs(pet) do
				if pe:GetLabel()~=id then return true end
			end
			return false
		end
		--attack redirect
		local age=Effect.GlobalEffect()
		age:SetType(EFFECT_TYPE_FIELD)
		age:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
		age:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		age:SetTargetRange(0,1)
		Duel.RegisterEffect(age,tp)
		--set spell/trap
		local sge=Effect.CreateEffect(e:GetHandler())
		sge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		sge:SetCode(EVENT_FREE_CHAIN)
		sge:SetCondition(s.setactcon)
		sge:SetOperation(s.setactop)
		Duel.RegisterEffect(sge,tp)
		--chain effect
		local cge=Effect.GlobalEffect()
		cge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		cge:SetCode(EVENT_CHAINING)
		cge:SetCondition(s.chainactcon)
		cge:SetOperation(s.chainactop)
		Duel.RegisterEffect(cge,tp)

		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_DECK,nil),true)
		--Summon
		local e1=Effect.GlobalEffect()
		e1:SetDescription(aux.Stringid(id+1,10))
		e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(s.sumcon)
		e1:SetOperation(s.sumactivate)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetTargetRange(0,LOCATION_HAND)
		ge1:SetLabelObject(e1)
		Duel.RegisterEffect(ge1,tp)
		--SpecialSummon
		local e2=Effect.GlobalEffect()
		e2:SetDescription(aux.Stringid(id+1,10))
		e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e2:SetCondition(s.spscon)
		e2:SetTarget(s.sptarget)
		e2:SetOperation(s.spactivate)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTargetRange(0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
		ge2:SetLabelObject(e2)
		Duel.RegisterEffect(ge2,tp)
		--PendulumSummon
		local e3=Effect.GlobalEffect()
		e3:SetDescription(aux.Stringid(id+1,10))
		e3:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_PZONE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e3:SetCondition(s.pspcon)
		e3:SetOperation(s.pspactivate)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge3:SetTargetRange(0,LOCATION_SZONE)
		ge3:SetLabelObject(e3)
		Duel.RegisterEffect(ge3,tp)
		--SSet
		local e4=Effect.GlobalEffect()
		e4:SetDescription(1153)
		e4:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e4:SetRange(LOCATION_HAND)
		e4:SetCondition(s.ssetcon)
		e4:SetOperation(s.ssetactivate)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge4:SetTargetRange(0,LOCATION_HAND)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,tp)
		s.mindplayer=tp
		s.controltable={age,sge,cge,ge0,ge1,ge2,ge3,ge4}
		if not KOISHI_CHECK then return end
		local g=Duel.GetFieldGroup(0,0x7f,0x7f)
		local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
		g:Merge(xg)
		for tc in aux.Next(g) do
			local cm=_G["c"..tc:GetOriginalCode()]
			if not cm.Is_Add_Effect_Id then
				local inie=cm.initial_effect
				local function addinit(c)
					cm.Is_Add_Effect_Id=true
					local _CReg=Card.RegisterEffect
					Card.RegisterEffect=function(card,effect,...)
						if effect and s.Control_Mode then   
							if effect:GetType()&EFFECT_TYPE_GRANT~=0 then
								local labeff=s.change_effect(effect:GetLabelObject(),card,tp)
								if aux.GetValueType(labeff)=="Effect" then
									local eff=effect:Clone()
									eff:SetLabelObject(labeff)
									_CReg(card,eff,...)
								end
							else
								local eff,bool=s.change_effect(effect,card,tp)
								if bool then
									local cs=getmetatable(c)
									local etable=cs.chain_effect_table
									if etable then table.insert(etable,effect) else etable={effect} end
									cs.chain_effect_table=etable
								end
								if aux.GetValueType(eff)=="Effect" then
									_CReg(card,eff,...)
								end
							end 
						end
						return _CReg(card,effect,...)   
					end
					if inie then inie(c) end
					Card.RegisterEffect=_CReg
				end
				cm.initial_effect=addinit
			end
			s.resetcard(tc)
		end
	else
		Debug.Message("骇入结束")
		Card.IsPublic=_Card.IsPublic

		Group.Select=_Group.Select
		Group.FilterSelect=_Group.FilterSelect
		Group.SelectUnselect=_Group.SelectUnselect
		Card.RemoveOverlayCard=_Card.RemoveOverlayCard
		Duel.SelectMatchingCard=_Duel.SelectMatchingCard
		Duel.SelectReleaseGroup=_Duel.SelectReleaseGroup
		Duel.SelectReleaseGroupEx=_Duel.SelectReleaseGroupEx
		Duel.SelectTarget=_Duel.SelectTarget
		Duel.SelectTribute=_Duel.SelectTribute
		Duel.DiscardHand=_Duel.DiscardHand
		Duel.RemoveOverlayCard=_Duel.RemoveOverlayCard
		Duel.SelectFusionMaterial=_Duel.SelectFusionMaterial

		Duel.SpecialSummon=_Duel.SpecialSummon
		Duel.SpecialSummonStep=_Duel.SpecialSummonStep
		Duel.MoveToField=_Duel.MoveToField
		Duel.SSet=_Duel.SSet
		Duel.GetControl=_Duel.GetControl
		Duel.SelectDisableField=_Duel.SelectDisableField
		Duel.SelectField=_Duel.SelectField

		Duel.SelectEffectYesNo=_Duel.SelectEffectYesNo
		Duel.SelectYesNo=_Duel.SelectYesNo
		Duel.SelectOption=_Duel.SelectOption
		Duel.SelectPosition=_Duel.SelectPosition
		
		Duel.AnnounceCoin=_Duel.AnnounceCoin
		Duel.AnnounceCard=_Duel.AnnounceCard
		Duel.AnnounceNumber=_Duel.AnnounceNumber

		Duel.ConfirmCards=_Duel.ConfirmCards
		Duel.Hint=_Duel.Hint
		
		for _,eff in ipairs(s.controltable) do
			eff:Reset()
		end
		s.controltable={}
	end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.SummonUnit=e:GetHandler()
	local res=s.SummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false)
	s.SummonUnit=nil
	return s.Control_Mode and tp~=c:GetOwner() and res
end
function s.sumfilter(c)
	return c:IsSummonable(false,nil) or c:IsMSetable(false,nil)
end
function s.sumtarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if s.SummonUnit then
			return s.SummonUnit:IsSummonable(false,nil) or s.SummonUnit:IsMSetable(false,nil)
		end
		return Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) 
	end
end
function s.sumzone(c,tp)
	local zone=0
	s.SummonUnit=c
	for i=0,4 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue((1<<i)*0x10000)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSummonable(false,nil) or c:IsMSetable(false,nil) then
			zone=zone|((1<<i)*0x10000)
		end
		e1:Reset()
	end
	for i=0,4 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue(1<<i)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSummonable(false,nil) or c:IsMSetable(false,nil) then
			zone=zone|((1<<i))
		end
		e1:Reset()
	end
	s.SummonUnit=nil
	return zone
end
function s.sumactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsSummonable(false,nil)
	local s2=c:IsMSetable(false,nil)
	local flag=s.sumzone(c,1-tp)
	if (s1 and s2 and _Duel.SelectPosition(s.mindplayer,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or (s1 and not s2) then   
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~flag,c:GetOriginalCode())
		if zone<0x10000 then
			Duel.Summon(1-s.mindplayer,c,false,nil,0,zone)
		else
			Duel.Summon(1-s.mindplayer,c,false,nil,0,zone/0x10000)
		end
	elseif s2 then
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~flag,c:GetOriginalCode())
		if zone<0x10000 then
			Duel.MSet(1-s.mindplayer,c,false,nil,0,zone)
		else
			Duel.MSet(1-s.mindplayer,c,false,nil,0,zone/0x10000)
		end
	end
end
function s.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.SpecialSummonUnit=c
	local res=s.SpecialSummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false)
	s.SpecialSummonUnit=nil
	return s.Control_Mode and tp~=c:GetOwner() and res
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSpecialSummonable() end
end
function s.spactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSpecialSummonable() then return end
	local s1=c:IsSpecialSummonable(SUMMON_TYPE_FUSION)
	local s2=c:IsSpecialSummonable(SUMMON_TYPE_SYNCHRO)
	local s3=c:IsSpecialSummonable(SUMMON_TYPE_XYZ)
	local s4=c:IsSpecialSummonable(SUMMON_TYPE_LINK)
	local op=0
	if s1 or s2 or s3 or s4 then
		op=aux.SelectFromOptions(s.mindplayer,{s1,1169},{s2,1164},{s3,1165},{s4,1166})
	end
	local zoneable=s.spsumzone(c,1-tp)
	if zoneable==0 then return end
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~zoneable,c:GetOriginalCode())
	--zone limit
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(zone)
	Duel.RegisterEffect(e1,s.mindplayer)
	if op==0 then
		Duel.SpecialSummonRule(1-s.mindplayer,c,0)
	elseif op==1 then
		Duel.SpecialSummonRule(1-s.mindplayer,c,SUMMON_TYPE_FUSION)
	elseif op==2 then
		Duel.SpecialSummonRule(1-s.mindplayer,c,SUMMON_TYPE_SYNCHRO)
	elseif op==3 then
		Duel.SpecialSummonRule(1-s.mindplayer,c,SUMMON_TYPE_XYZ)
	elseif op==4 then
		Duel.SpecialSummonRule(1-s.mindplayer,c,SUMMON_TYPE_LINK)
	end
	e1:Reset()
end
function s.sptarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if s.SpecialSummonUnit then
			return s.SpecialSummonUnit:IsSpecialSummonable()
		end
		return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) 
	end
end
function s.spsumzone(c,tp)
	local zone=0
	for i=0,4 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue((1<<i)*0x10000)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSpecialSummonable() then
			zone=zone|((1<<i)*0x10000)
		end
		e1:Reset()
	end
	for i=0,4 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue(1<<i)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSpecialSummonable() then
			zone=zone|((1<<i))
		end
		e1:Reset()
	end
	for i=0,0 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue(0x200040)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSpecialSummonable() then
			zone=zone|0x200040
		end
		e1:Reset()
	end
	for i=0,0 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue(0x400020)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if c:IsSpecialSummonable() then
			zone=zone|0x400020
		end
		e1:Reset()
	end
	return zone
end
function s.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local lpz=Duel.GetFieldCard(p,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_MONSTER)
	if #g==0 then return false end
	return s.Control_Mode and p~=e:GetHandler():GetOwner() and aux.PendCondition(e,lpz,g)
end
function s.pspactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_MONSTER)
	if #g==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCountLimit(1)
	e1:SetOperation(s.pspop)
	Duel.RegisterEffect(e1,tp)
	Duel.RaiseEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0)
end
function s.pspop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_MONSTER)
	if #g==0 then return end
	aux.PendOperation(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
	e:Reset()
end
function s.atarget(e,c)
	return c==e:GetHandler()
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if eg then s.sumgroup:Merge(eg) end
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_END)
	ge1:SetLabelObject(s.sumgroup)
	ge1:SetOperation(s.sumresetop)
	Duel.RegisterEffect(ge1,0)
end
function s.sumsop(e,tp,eg,ep,ev,re,r,rp)
	if eg then s.sumsgroup:Merge(eg) end
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_END)
	ge1:SetLabelObject(s.sumsgroup)
	ge1:SetOperation(s.sumresetop)
	Duel.RegisterEffect(ge1,0)
end
function s.sumresetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Clear()
	e:Reset()
end
function s.ssetcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return s.Control_Mode and tp~=e:GetHandler():GetOwner() and c:IsSSetable()
end
function s.ssetactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tep=c:GetControler()
	if c:IsSSetable() then
		Duel.SSet(tep,c,tep,false)
	end
end
function s.chainactfilter(c,eg,ep,ev,re,r,rp)
	local etable=c.chain_effect_table
	if not etable then return end
	local atable={}
	for _,v in ipairs(etable) do
		if (v:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_SZONE) and c:IsFacedown() or not v:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsFaceupEx() and v:IsHasRange(c:GetLocation())) then
			local con=v:GetCondition()
			if not con then con=aux.TRUE end
			local cost=v:GetCost()
			if not cost then cost=aux.TRUE end
			local tg=v:GetTarget()
			if not tg then tg=aux.TRUE end
			if con(v,c:GetControler(),eg,ep,ev,re,r,rp) and cost(v,c:GetControler(),eg,ep,ev,re,r,rp,0) and tg(v,c:GetControler(),eg,ep,ev,re,r,rp,0) and v:CheckCountLimit(c:GetControler()) then
				table.insert(atable,v)
			end
		end
	end
	return table.unpack(atable)
end
function s.chainactcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.chainactfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,nil,eg,ep,ev,re,r,rp)
end
function s.chainactop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.chainactfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil,eg,ep,ev,re,r,rp)
	if g:GetCount()>0 then
		local sg=g:CancelableSelect(tp,1,1,nil)
		if sg then
			local sc=sg:GetFirst()
			local etable={s.chainactfilter(sc,eg,ep,ev,re,r,rp)}
			local se=etable[1]
			if #etable>1 then
				local op=aux.SelectFromOptions(tp,
				{#etable>=1 and etable[1],etable[1]:GetDescription()},
				{#etable>=2 and etable[2],etable[2]:GetDescription()},
				{#etable>=3 and etable[3],etable[3]:GetDescription()},
				{#etable>=4 and etable[4],etable[4]:GetDescription()},
				{#etable>=5 and etable[5],etable[5]:GetDescription()})
				se=etable[op]
			end
			local code=sc:GetOriginalCode()
			local eff=se:Clone()
			if se:GetType()&EFFECT_TYPE_ACTIVATE~=0 then
				eff:SetProperty(se:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
				eff:SetRange(LOCATION_HAND+LOCATION_SZONE)
			end
			eff:SetDescription(aux.Stringid(id+1,9))
			eff:SetType(EFFECT_TYPE_QUICK_F)
			eff:SetCode(233+code)
			eff:SetCost(s.addeffcost(se))
			eff:SetCondition(s.addeffcon(se))
			eff:SetTarget(s.addefftg(se))
			eff:SetOperation(s.addeffop(se))
			eff:SetReset(RESET_CHAIN)
			sc:RegisterEffect(eff,true) 
			Duel.RaiseEvent(eg,233+code,re,r,rp,ep,ev)
		end
	end
end
function s.setactfilter(c)
	local ae=c:GetActivateEffect()
	if ae and ae:GetCode()==EVENT_FREE_CHAIN then
		local ph=Duel.GetCurrentPhase()
		return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or c:IsType(TYPE_QUICKPLAY+TYPE_TRAP)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and ae:IsActivatable(c:GetControler(),false,false)
	else
		return false
	end
end
function s.setactcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.setactfilter,tp,0,LOCATION_SZONE,1,nil)
end
function s.setactop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.setactfilter,tp,0,LOCATION_SZONE,nil)
	if sg:GetCount()==0 then return end
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	local effect=tc:GetActivateEffect()
	local eff=effect:Clone()
	local code=tc:GetOriginalCode()
	if eff and aux.GetValueType(eff)=="Effect" then
		eff:SetProperty(effect:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
		eff:SetRange(LOCATION_SZONE)
		eff:SetDescription(aux.Stringid(id+1,9))
		eff:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		eff:SetCode(233+code)
		eff:SetCost(s.addeffcost(effect))
		eff:SetCondition(s.addeffcon(effect))
		eff:SetTarget(s.addefftg(effect))
		eff:SetOperation(s.addeffop(effect))
		eff:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(eff,true)
	end
	Duel.ChangePosition(tc,POS_FACEUP)
	Duel.RaiseSingleEvent(tc,233+code,re,r,1-tp,1-tp,ev)
end
function s.change_effect(effect,c,mp)
	local cardtype=c:GetType()
	local code=c:GetOriginalCode()
	local eff=Effect.CreateEffect(c)
	eff:SetDescription(aux.Stringid(id+1,9))
	eff:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_QUICK_O)   
	eff:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	eff:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	eff:SetLabelObject(effect)
	eff:SetLabel(mp)
	eff:SetCondition(s.mindcon)
	if effect:GetType()&EFFECT_TYPE_IGNITION~=0 then
		eff:SetRange(effect:GetRange())
		eff:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_IGNITION)
		eff:SetTarget(s.mindtg)
		return eff
	elseif effect:GetType()&EFFECT_TYPE_QUICK_O~=0 then
		if effect:GetCode()==EVENT_FREE_CHAIN then
			eff:SetCode(EVENT_FREE_CHAIN)
			eff:SetRange(effect:GetRange())
			eff:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_QUICK_O)
			eff:SetTarget(s.mindtg2)
			return eff,true
		elseif effect:GetCode()==EVENT_CHAINING or effect:GetCode()==EVENT_BECOME_TARGET then
			return 0,true
		else
			return 0
		end
	elseif effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 and not c:IsType(TYPE_MONSTER) then
		eff:SetCondition(s.mindcon2)
		eff:SetRange(LOCATION_HAND+LOCATION_SZONE)
		if cardtype&(TYPE_QUICKPLAY+TYPE_TRAP)~=0 then
			if effect:GetCode()==EVENT_FREE_CHAIN then
				eff:SetCode(EVENT_FREE_CHAIN)
				eff:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_QUICK_O)
				eff:SetTarget(s.mindtg2)
				return eff,true
			elseif effect:GetCode()==EVENT_CHAINING or effect:GetCode()==EVENT_BECOME_TARGET then
				return 0,true
			else
				return 0
			end
		else
			eff:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_IGNITION)
			eff:SetTarget(s.mindtg)
			return eff
		end
	else
		return 0
	end
end
function s.mindcon(e,tp)
	local effect=e:GetLabelObject()
	local mp=e:GetLabel()
	local c=e:GetHandler()
	local tep=c:GetControler()
	return s.Control_Mode and tp~=tep and tp==mp and effect:IsActivatable(tep,false,false)
end
function s.mindcon2(e,tp)
	local effect=e:GetLabelObject()
	local c=e:GetHandler()
	local mp=e:GetLabel()
	local tep=c:GetControler()
	Duel.DisableActionCheck(true) 
	local dc=Duel.CreateToken(tep,effect:GetHandler():GetOriginalCode())
	local ae=dc:GetActivateEffect()
	local bool1,bool2=pcall(Effect.IsActivatable,ae,tep,false,false)
	Duel.DisableActionCheck(false)
	return s.Control_Mode and (c:IsFacedown() or not c:IsLocation(LOCATION_SZONE)) and tp~=tep and tp==mp and bool1 and bool2
end
function s.addeffcost(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,...)
		local cost=effect:GetCost()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 or effect:GetType()&EFFECT_TYPE_QUICK_F and c:IsType(TYPE_SPELL+TYPE_TRAP) then
			if chk==0 then
				return (not c:IsLocation(LOCATION_HAND) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,chk,...))
			else
				e:SetType(EFFECT_TYPE_ACTIVATE)
				e:Reset()
				if c:IsLocation(LOCATION_SZONE) then Duel.ChangePosition(c,POS_FACEUP) end
				if c:IsLocation(LOCATION_HAND) then
					if c:IsType(TYPE_FIELD) then
						Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
					else
						Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
				end
				if cost then cost(e,tp,eg,ep,ev,re,r,rp,chk,...) end
			end
		else
			if chk==0 then
				return not cost or cost(e,tp,eg,ep,ev,re,r,rp,chk,...)
			else
				--e:SetType(effect:GetType())
				--e:SetCode(effect:GetCode())
				e:Reset()
				if cost then cost(e,tp,eg,ep,ev,re,r,rp,chk,...) end
			end
		end
	end
end
function s.addeffcon(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,...)
		local con=effect:GetCondition()
		local c=e:GetHandler()
		return not con or con(e,tp,eg,ep,ev,re,r,rp,...)
	end
end
function s.addefftg(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,...)
		local tg=effect:GetTarget()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if chk==0 then
			return (not tg or tg(e,tp,eg,ep,ev,re,r,rp,chk,...))
		else
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,chk,...) end
		end
	end
end
function s.addeffop(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,...)
		local op=effect:GetOperation()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 and c:GetType()&(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP)==0 then c:CancelToGrave(false) end
		if op then op(e,tp,eg,ep,ev,re,r,rp,...) end
	end
end
function s.mindtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local effect=e:GetLabelObject()
	local eff=effect:Clone()
	local mp=e:GetLabel()
	local c=effect:GetHandler()
	local code=c:GetOriginalCode()
	if eff and aux.GetValueType(eff)=="Effect"then
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 then
			eff:SetProperty(effect:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
			eff:SetRange(LOCATION_HAND+LOCATION_SZONE)
		end
		eff:SetDescription(aux.Stringid(id+1,9))
		eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		eff:SetCode(233+code)
		eff:SetCost(s.addeffcost(effect))
		eff:SetCondition(s.addeffcon(effect))
		eff:SetTarget(s.addefftg(effect))
		eff:SetOperation(s.addeffop(effect))
		eff:SetReset(RESET_CHAIN)
		c:RegisterEffect(eff,true)
	end
	local erg=Group.CreateGroup()
	local fre=Effect.GlobalEffect()
	local feg=Group.CreateGroup()
	local ftp=1-tp
	Duel.RaiseEvent(feg,233+code,fre,r,frp,frp,ev)
end
function s.mindtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local effect=e:GetLabelObject()
	local eff=effect:Clone()
	local mp=e:GetLabel()
	local c=effect:GetHandler()
	local code=c:GetOriginalCode()
	if eff and aux.GetValueType(eff)=="Effect"then
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 then
			eff:SetProperty(effect:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
			eff:SetRange(LOCATION_HAND+LOCATION_SZONE)
		end
		eff:SetDescription(aux.Stringid(id+1,9))
		eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		eff:SetCode(233+code)
		eff:SetCost(s.addeffcost(effect))
		eff:SetCondition(s.addeffcon(effect))
		eff:SetTarget(s.addefftg(effect))
		eff:SetOperation(s.addeffop(effect))
		eff:SetReset(RESET_CHAIN)
		c:RegisterEffect(eff,true)
		local eff2=eff:Clone()
		eff2:SetType(EFFECT_TYPE_QUICK_F)
		eff2:SetCode(EVENT_CHAINING)
		eff2:SetRange(effect:GetRange())
		c:RegisterEffect(eff2,true)
	end
	local erg=Group.CreateGroup()
	local fre=Effect.GlobalEffect()
	local feg=Group.CreateGroup()
	local ftp=1-tp
	local effectcode=effect:GetCode()
	if effectcode==EVENT_CHAINING then
		fre,ftp=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local fc=fre:GetHandler()
		feg:AddCard(fc)
	end
	if effectcode==EVENT_SUMMON or effectcode==EVENT_FLIP_SUMMON or effectcode==EVENT_SPSUMMON then
		feg:Merge(s.sumgroup)
	end
	if effectcode==EVENT_SUMMON_SUCCESS or effectcode==EVENT_FLIP_SUMMON_SUCCESS or effectcode==EVENT_SPSUMMON_SUCCESS then
		feg:Merge(s.sumsgroup)
	end
	Duel.RaiseEvent(feg,233+code,fre,r,frp,frp,ev)
end
function s.wildop()
	s.Wild_Mode=not s.Wild_Mode
	local g=Duel.GetFieldGroup(0,0x7f,0x7f)
	local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
	g:Merge(xg)
	if s.Wild_Mode then
		Debug.Message("歼灭模式 开")
		s.SetCountLimit=Effect.SetCountLimit
		function Effect.SetCountLimit(e,count,...)
			s.SetCountLimit(e,1,EFFECT_COUNT_CODE_CHAIN)
		end
		for tc in aux.Next(g) do
			s.resetcard(tc)
		end
		Effect.SetCountLimit=s.SetCountLimit
	else
		Debug.Message("歼灭模式 关")
		for tc in aux.Next(g) do
			s.resetcard(tc)
		end
	end
end
function s.randomop(tp)
	s.Random_Mode=not s.Random_Mode
	if s.Random_Mode then
		Debug.Message("灌铅骰子 开")
		function Group.RandomSelect(g,p,count)
			return _Group.Select(g,tp,count,count,nil)
		end
		function Duel.TossCoin(p,count)
			local ct={}
			if count==-1 then
				local i=1
				local coin=1
				while i<=20 and coin==1 do
					coin=1-_Duel.AnnounceCoin(tp)
					table.insert(ct,coin)
					i=i+1
				end
				_Duel.TossCoin(p,i)
				Duel.SetCoinResult(table.unpack(ct))
			else
				for i=1,count do 
					table.insert(ct,1-_Duel.AnnounceCoin(tp)) 
				end
				_Duel.TossCoin(p,count)
				Duel.SetCoinResult(table.unpack(ct))
			end
			return table.unpack(ct)
		end
		function Duel.TossDice(p,count)
			local ac=_Duel.AnnounceNumber(tp,1,2,3,4,5,6,7)
			return ac
		end
	else
		Debug.Message("灌铅骰子 关")
		Group.RandomSelect=_Group.RandomSelect
		Duel.TossCoin=_Duel.TossCoin
		Duel.TossDice=_Duel.TossDice
	end
end
function s.toolop(tp)
	local op=_Duel.SelectOption(tp,aux.Stringid(id+1,11),aux.Stringid(id+1,12),aux.Stringid(id+1,13),aux.Stringid(id+1,14),aux.Stringid(id+1,15))
	if op==0 then
		local p=_Duel.SelectOption(tp,aux.Stringid(id+1,1),aux.Stringid(id+1,2))==0 and tp or 1-tp
		local lp=_Duel.AnnounceNumber(tp,80000,16000,8000,4000,2000,1000,500,100,1)
		Duel.SetLP(p,lp)
	elseif op==1 then
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		local sg=Group.CreateGroup()
		for tc in aux.Next(g) do
			for counter=0x1,0x999 do
				local loc=tc:GetLocation()
				if tc:IsLocation(LOCATION_PZONE) then loc=LOCATION_PZONE end
				if tc:IsCanAddCounter(counter,1,false,loc) then
					sg:AddCard(tc)
					counter=0x999
				end
			end
		end
		if sg:GetCount()==0 then
			Debug.Message("场上没有可以放置专属指示物的卡片！")
			return
		else
			local ac=_Group.Select(sg,tp,1,1,nil):GetFirst()
			for counter=0x1,0x999 do
				local loc=ac:GetLocation()
				if ac:IsLocation(LOCATION_PZONE) then loc=LOCATION_PZONE end
				if ac:IsCanAddCounter(counter,1,false,loc) then
					local max=0
					local t={}
					for i=1,20 do
						if ac:IsCanAddCounter(counter,i) then
							max=i
							i=20
						end
					end
					if max>1 then
						for i=1,max do
							t[i]=max-i+1
						end
						ac:AddCounter(counter,_Duel.AnnounceNumber(tp,table.unpack(t)))
					else
						ac:AddCounter(counter,1)
					end
					return
				end
			end
		end
	elseif op==2 then
		local p=_Duel.SelectOption(tp,aux.Stringid(id+1,1),aux.Stringid(id+1,2))==0 and tp or 1-tp
		if p==1-tp then Duel.ConfirmCards(tp,Duel.GetFieldGroup(p,LOCATION_DECK,0)) end
		local sg=_Duel.SelectMatchingCard(tp,aux.TRUE,p,LOCATION_DECK,0,1,16,nil)
		for tc in aux.Next(sg) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		if sg:GetCount()>1 then Duel.SortDecktop(tp,p,sg:GetCount()) end
	elseif op==3 then
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			if Duel.GetTurnCount()==1 then
				if KOISHI_CHECK then			
					Duel.MoveTurnCount()					
				else
					Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
					local e1=Effect.GlobalEffect()
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_SKIP_TURN)
					e1:SetTargetRange(0,1)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					Duel.RegisterEffect(e1,tp)
					Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
					Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
				end
			end
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_BATTLE_START+RESET_SELF_TURN,1)
		else
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetTargetRange(0,1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			Duel.RegisterEffect(e1,tp)
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)  
		end
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_EP)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE_START+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
	elseif op==4 then   
		if not KOISHI_CHECK then
			Debug.Message("该功能需要koishi函数！")
			return
		end
		Duel.ResetTimeLimit(0,999)
		Duel.ResetTimeLimit(1,999)
	end
end
function s.testop(e,tp)
	local c=e:GetHandler()
	local op1=_Duel.SelectOption(tp,aux.Stringid(id+2,2),aux.Stringid(id+2,3),aux.Stringid(id,0),1212)
	if op1==0 then
		local op2=_Duel.SelectOption(tp,1151,aux.Stringid(id+2,6))
		if op2==0 then
			local op3=_Duel.SelectOption(tp,4,5,6)
			if op3==0 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_SUMMON_SUCCESS,e,0,tp,tp,0)
			elseif op3==1 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_SPSUMMON_SUCCESS,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_SPSUMMON_SUCCESS,e,0,tp,tp,0)
			elseif op3==2 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_FLIP_SUMMON_SUCCESS,e,0,tp,tp,0)
					Duel.RaiseSingleEvent(tc,EVENT_FLIP,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_FLIP_SUMMON_SUCCESS,e,0,tp,tp,0)
				Duel.RaiseEvent(eg,EVENT_FLIP,e,0,tp,tp,0)
			end
		elseif op2==1 then
			local op3=_Duel.SelectOption(tp,1103,1102,aux.Stringid(id+2,7),aux.Stringid(id+2,8))
			if op3==0 then
				local eg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_TO_GRAVE,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_TO_GRAVE,e,0,tp,tp,0)
			elseif op3==1 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_REMOVED,LOCATION_REMOVED,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_REMOVE,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_REMOVE,e,0,tp,tp,0)
			elseif op3==2 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceupEx,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_EFFECT+REASON_BATTLE,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_DESTROYED,e,REASON_EFFECT+REASON_BATTLE,tp,tp,0)
			elseif op3==3 then
				local eg=Duel.SelectMatchingCard(tp,Card.IsFaceupEx,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,0,99,nil)
				if eg:GetCount()==0 then return end
				for tc in aux.Next(eg) do
					Duel.RaiseSingleEvent(tc,EVENT_RELEASE,e,0,tp,tp,0)
				end
				Duel.RaiseEvent(eg,EVENT_RELEASE,e,0,tp,tp,0)
			 end
		 end
	elseif op1==1 then
		local msg=_Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,18,19,20,22,23,24,25,26,30,31,32,33,34,35,36,37,38,39,40,41,42,50,53,54,55,56,60,61,62,63,64,65,70,71,72,73,74,75,76,80,81,83,90,91,92,93,94,95,96,97,100,101,102,110,111,112,113,114,120,121,122,123,130,131,132,133,140,141,142,143,160,161,162,163,164,165,170,180)
		s.Administrator(msg)
	elseif op1==2 then
		local ot=_Duel.SelectOption(tp,1190,1191,1192,1105)
		if ot==0 then
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0x7d,0,1,99,c)
			Duel.SendtoHand(g,1-tp,REASON_RULE)
		elseif ot==1 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x6f,0,1,99,c)
			local g1=g:Filter(Card.IsControler,nil,1-tp)
			local g2=g:Filter(Card.IsControler,nil,tp)  
			Duel.SendtoGrave(g1,REASON_RULE)
			for tc in aux.Next(g2) do
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_DECK_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_GRAVE)
				tc:RegisterEffect(e1,true)
				Duel.SendtoDeck(tc,1-tp,1,REASON_RULE)
			end   
		elseif ot==2 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x5f,0,1,99,c)
			local g1=g:Filter(Card.IsControler,nil,1-tp)
			local g2=g:Filter(Card.IsControler,nil,tp)
			local pos=Duel.SelectPosition(tp,g:GetFirst(),0x3)
			if pos==POS_FACEUP_ATTACK then
				Duel.Remove(g1,POS_FACEUP,REASON_RULE)
			else
				Duel.Remove(g1,POS_FACEDOWN,REASON_RULE)
			end
			for tc in aux.Next(g2) do
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_DECK_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e1,true)
				Duel.SendtoDeck(tc,1-tp,1,REASON_RULE)
			end   
		elseif ot==3 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x3e,0,1,99,c)
			Duel.SendtoDeck(g,1-tp,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	else
		return 
	end
end