local s,id,o=GetID()
function s.initial_effect(c)
	if not s.globle_check then
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
		s.Theworld_Mode=false
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
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge0:SetOperation(s.startop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.adjustcon)
		ge1:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge1,0)
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
		s.RandomSelect=Group.RandomSelect
		s.TossCoin=Duel.TossCoin
		s.TossDice=Duel.TossDice

		s.Select=Group.Select
		s.FilterSelect=Group.FilterSelect
		s.SelectUnselect=Group.SelectUnselect
		s.CRemoveOverlayCard=Card.RemoveOverlayCard
		s.SelectMatchingCard=Duel.SelectMatchingCard
		s.SelectReleaseGroup=Duel.SelectReleaseGroup
		s.SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		s.SelectTarget=Duel.SelectTarget
		s.SelectTribute=Duel.SelectTribute
		s.DiscardHand=Duel.DiscardHand
		s.DRemoveOverlayCard=Duel.RemoveOverlayCard
		s.SelectFusionMaterial=Duel.SelectFusionMaterial

		s.SpecialSummon=Duel.SpecialSummon
		s.SpecialSummonStep=Duel.SpecialSummonStep

		s.SelectEffectYesNo=Duel.SelectEffectYesNo
		s.SelectYesNo=Duel.SelectYesNo
		s.SelectOption=Duel.SelectOption
		s.SelectPosition=Duel.SelectPosition
		
		s.AnnounceCoin=Duel.AnnounceCoin
		s.AnnounceCard=Duel.AnnounceCard
		s.AnnounceNumber=Duel.AnnounceNumber

		s.ConfirmCards=Duel.ConfirmCards
		s.Hint=Duel.Hint	 
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.cfilter(c)
	return c:GetOriginalCode()==id
end
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,0,0xff,0xff,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(0)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(s.menucon)
		e2:SetOperation(s.menuop)
		tc:RegisterEffect(e2,true)
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
	local g=Duel.GetMatchingGroup(s.cfilter2,tp,0xff,0xff,nil)
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
					local cost=te2:GetCost()
					if not con then con=aux.TRUE end
					te2:SetCondition(s.chcon(con))
				end
				if te2:GetType()==EFFECT_TYPE_FIELD then
					local tg=te2:GetTarget()
					local o,h=te2:GetOwner(),te2:GetHandler()
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
		elseif tg(te3,c,tp,SUMMON_TYPE_SPECIAL,POS_FACEUP,tp,e)==true then
			te3:SetTarget(s.chtg2(tg))
		end
	end
	for _,te4 in pairs(re4) do
		local tg=te4:GetTarget()
		if tg(te4,c,tp,tp,POS_FACEUP)==true then
			te4:SetTarget(s.chtg2(tg))
		end
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
				if c:IsHasEffect(id) and c:GetFlagEffect(id)==0 then return false end
				return _tg(e,c,...)
			end
end
function s.chtg2(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
				if c:IsHasEffect(id) and se:GetHandler()==c and c:GetFlagEffect(id)==0 then return false end
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
function s.menucon(e,tp,eg,ep,ev,re,r,rp)
	return tp==e:GetHandler():GetOwner()
end
function s.menuop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local page=1
	local ot=0
	while page~=0 do
		if page==1 then
			local desc=s.Cheating_Mode and 4 or 3
			ot=s.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,desc),aux.Stringid(id,5))
			if ot==0 then
				s.movecard(e,tp)
				page=0
			elseif ot==1 then
				s.printcard(e,tp)
				page=0
			elseif ot==2 then
				s.setcard(tp)
				page=0
			elseif ot==3 then
				s.cheatmode(e:GetHandler())
				page=0
			elseif ot==4 then
				page=page+1
			end
		elseif page==2 then
			local desc1=s.Hint_Mode and 14 or 13
			local desc2=s.Control_Mode and 4 or 3
			ot=s.SelectOption(tp,aux.Stringid(id,6),aux.Stringid(id,desc1),aux.Stringid(id,15),aux.Stringid(id+1,desc2),aux.Stringid(id,5))
			if ot==0 then
				page=page-1
			elseif ot==1 then
				s.hintcard()
				page=0
			elseif ot==2 then
				s.loadmenu(tp)
				page=0
			elseif ot==3 then
				s.mindcontrol(e,tp)
				page=0
			elseif ot==4 then
				page=page+1
			end
		elseif page==3 then
			local desc1=s.Wild_Mode and 6 or 5
			local desc2=s.Random_Mode and 8 or 7
			local desc3=s.Theworld_Mode and 10 or 9
			ot=s.SelectOption(tp,aux.Stringid(id,6),aux.Stringid(id+1,desc1),aux.Stringid(id+1,desc2),1212)
			if ot==0 then
				page=page-1
			elseif ot==1 then
				s.wildop()
				page=0
			elseif ot==2 then
				s.randomop(tp)
				page=0
			--elseif ot==3 then
			--  s.theworldop()
			--  page=0
			elseif ot==3 then
				page=0
			end
		end
	end
	if not s.Theworld_Mode then Duel.AdjustAll() end
end
function s.movecard(e,tp)
	local c=e:GetHandler()
	local ot=s.SelectOption(tp,1152,1190,1191,1192,1105)
	if ot==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetCountLimit(1)
		e1:SetOperation(s.movespop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e1,tp)
		Duel.RaiseEvent(c,EVENT_CUSTOM+id,e,0,tp,tp,0)
	elseif ot==1 then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0xfd,0,1,99,c)
		Duel.SendtoHand(g,tp,REASON_RULE)
	elseif ot==2 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0xef,0,1,99,c)
		Duel.SendtoGrave(g,REASON_RULE)
	elseif ot==3 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0xdf,0,1,99,c)
		local pos=Duel.SelectPosition(tp,g:GetFirst(),0x3)
		if pos==POS_FACEUP_ATTACK then
			Duel.Remove(g,POS_FACEUP,REASON_RULE)
		else
			Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		end
	elseif ot==4 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0xbe,0,1,99,c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end
function s.movespop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0xf3,0,c,TYPE_MONSTER)
	local sg=g:Select(tp,0,99,nil)
	if #sg==0 then
		sg=s.RandomSelect(g,tp,math.min(3,#g))
	end
	for tc in aux.Next(sg) do
		local cardtype=tc:GetType()
		local sumtype=0
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
		if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)==0 or not tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			Debug.Message("剩余空位不足！")
		elseif not tc:IsCanBeSpecialSummoned(e,0,tp,true,true) then
			Debug.Message("特召被限制，可尝试使用作弊模式s")
		else
			local bool=false
			if not tc:IsCanBeSpecialSummoned(e,sumtype,tp,false,false) and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(id,10)) then bool=true end
			if not Duel.SpecialSummonStep(tc,sumtype,tp,tp,bool,bool,POS_FACEUP+POS_FACEDOWN_DEFENSE) then
				Debug.Message("特殊召唤失败了！") 
			else
				if tc:IsType(TYPE_XYZ) then
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_SPSUMMON_SUCCESS)
					e1:SetProperty(EFFECT_FLAG_DELAY)
					e1:SetLabelObject(tc)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					e1:SetOperation(s.spxyzop)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
	Duel.SpecialSummonComplete()
	e:Reset()
end
function s.printcard(e,tp)
	local c=e:GetHandler()
	local ac=s.AnnounceCard(tp)
	local tc=Duel.CreateToken(tp,ac)
	Duel.SendtoHand(tc,nil,REASON_RULE)
	if s.Cheating_Mode then
		if tc:GetFlagEffect(id+10)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(id,11))
			e1:SetCode(EFFECT_SPSUMMON_PROC_G)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(SUMMON_VALUE_SELF) 
			e1:SetRange(0xd3)
			e1:SetCondition(s.spcon)
			e1:SetOperation(s.spop)				
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
			e2:SetDescription(aux.Stringid(id,11))
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
	if s.Control_Mode then
		local cm=_G["c"..tc:GetOriginalCode()]
		if not cm.Is_Add_Effect_Id then
			local inie=cm.initial_effect
			local function addinit(c)
				cm.Is_Add_Effect_Id=true
				local _CReg=Card.RegisterEffect
				Card.RegisterEffect=function(card,effect,...)
					if effect and s.Control_Mode then   
						if effect:GetType()&EFFECT_TYPE_GRANT~=0 then
							local labeff=s.change_effect(effect:GetLabelObject())
							if labeff~=0 then
								local eff=effect:Clone()
								eff:SetLabelObject(labeff)
								_CReg(card,eff,...)
							end
						else
							local eff=s.change_effect(effect,c)
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
		local ini=s.initial_effect
		s.initial_effect=function() end
		tc:ReplaceEffect(id,0)
		s.initial_effect=ini
		tc.initial_effect(tc)
	end
end
function s.setcard(tp)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
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
		if s.SelectOption(tp,aux.Stringid(id+1,1),aux.Stringid(id+1,2))==0 then
			flag=flag==2^5 and flag<<1 or flag>>1
		else
			p=1-tp
		end
		local mc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		local pos=POS_FACEUP_ATTACK
		if not mc:IsType(TYPE_LINK) then pos=Duel.SelectPosition(tp,mc,0xd) end
		Duel.MoveToField(mc,tp,p,LOCATION_MZONE,pos,true,flag)
		if tp~=p then
			local e1=Effect.CreateEffect(mc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(p)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
		end
	else		
		if flag>0xff00 then
			flag=flag>>16
			p=1-tp
		end
		if flag==0x100 or flag==0x1000 then
			mg:Merge(Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_PENDULUM))
		end
		if flag==0x2000 then 
			mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_FIELD)
		end
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		if flag>0x7f then
			if mc:IsType(TYPE_PENDULUM) and (flag==0x100 or flag==0x1000) and s.SelectOption(tp,1003,1009)==1 then
				Duel.MoveToField(mc,tp,p,LOCATION_PZONE,POS_FACEUP,true)
			else
				local pos=Duel.SelectPosition(tp,mc,0x3)
				flag=flag>>8
				Duel.MoveToField(mc,tp,p,LOCATION_SZONE,pos,true,flag)
			end
		else
			local pos=Duel.SelectPosition(tp,mc,0xd)							 
			Duel.MoveToField(mc,tp,p,LOCATION_MZONE,pos,true,flag)
			if tp~=p then
				local e1=Effect.CreateEffect(mc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_CONTROL)
				e1:SetValue(p)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				mc:RegisterEffect(e1)
			end
		end  
	end
end
function s.cheatmode(c)
	s.Cheating_Mode=not s.Cheating_Mode
	if s.Cheating_Mode then
		Debug.Message("规则限制已解除")
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetDescription(aux.Stringid(id,12))
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
		ge7:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
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
		local sg=Duel.GetMatchingGroup(s.addfilter,0,0xff,0xff,c)
		for tc in aux.Next(sg) do
			if tc:GetFlagEffect(id+10)==0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetDescription(aux.Stringid(id,11))
				e1:SetCode(EFFECT_SPSUMMON_PROC_G)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetValue(SUMMON_VALUE_SELF) 
				e1:SetRange(0xd3)
				e1:SetCondition(s.spcon)
				e1:SetOperation(s.spop)				
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
				e2:SetDescription(aux.Stringid(id,11))
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
	e1:SetDescription(aux.Stringid(id+1,11))
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
		e1:SetProperty(EFFECT_FLAG_DELAY)
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
		e1:SetDescription(aux.Stringid(id,11))
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(SUMMON_VALUE_SELF) 
		e1:SetRange(0xd3)
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop)				
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
		e2:SetDescription(aux.Stringid(id,11))
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
	local og=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0xff,0,0,99,c)
	for tc in aux.Next(og) do
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
	local str="这个效果可以被 "
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
	Debug.Message(str.."对应")
end
function s.saveop(e,tp,eg,ep,ev,re,r,rp)	
	s.autodata=s.save()
	local turn=s.autodata.turn
	Debug.Message("第"..turn.."回合 自动存档完成")
end
function s.loadmenu(tp)
	local ot=s.SelectOption(tp,aux.Stringid(id,7),aux.Stringid(id,8),aux.Stringid(id,9),1212)
	if ot==0 then
		s.manualdata=s.save()
		local turn=s.manualdata.turn
		Debug.Message("第"..turn.."回合 手动存档完成")
	elseif ot==1 then   
		s.loadcard(s.manualdata)
	elseif ot==2 then
		s.loadcard(s.autodata)
	elseif ot==3 then
		return
	end
end
function s.get_save_location(c)
	if c:IsLocation(LOCATION_PZONE) then return LOCATION_PZONE
	else return c:GetLocation() end
end
function s.get_save_sequence(c)
	if c:IsOnField() then return c:GetSequence()
	else return 0 end
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
function s.loadcard(data)
	Debug.Message("正在读档")
	Duel.Hint(HINT_CARD,0,id)
	local cg=Duel.GetFieldGroup(0,0xff,0xff)
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
				elseif cdata.location&LOCATION_ONFIELD>0 then
					if cdata.sequence>=5 then Duel.SendtoExtraP(tc,p,REASON_RULE) end
					if not Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true,2^cdata.sequence) then Duel.SendtoGrave(tc,REASON_RULE) end
					if tc:GetOwner()~=p then
						local e1=Effect.CreateEffect(tc)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_SET_CONTROL)
						e1:SetValue(p)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
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
function s.mindcontrol(e,tp)
	s.Control_Mode=not s.Control_Mode
	if s.Control_Mode then
		Debug.Message("骇入开始")
		function Group.Select(g,sp,min,max,nc) return s.Select(g,tp,min,max,nc) end
		function Group.FilterSelect(g,sp,...) return s.FilterSelect(g,tp,...) end
		function Group.SelectUnselect(cg,sg,sp,...) return s.SelectUnselect(cg,sg,tp,...) end
		function Card.RemoveOverlayCard(oc,sp,...) return s.CRemoveOverlayCard(oc,tp,...) end
		function Duel.SelectFusionMaterial(sp,...) return s.SelectFusionMaterial(tp,...) end
		function Duel.SelectTarget(sp,...) return s.SelectTarget(tp,...)end
		function Duel.SelectTribute(sp,...) return s.SelectTribute(tp,...)end
		function Duel.DiscardHand(sp,f,min,max,r,nc,...)
			local dg=Duel.SelectMatchingCard(tp,f,sp,LOCATION_HAND,0,min,max,nc,...)
			return Duel.SendtoGrave(dg,r)
		end
		function Duel.RemoveOverlayCard(sp,...) return s.DRemoveOverlayCard(tp,...) end
		function Duel.SelectMatchingCard(sp,...) return s.SelectMatchingCard(tp,...) end
		function Duel.SelectReleaseGroup(sp,...) return s.SelectReleaseGroup(tp,...) end
		function Duel.SelectReleaseGroupEx(sp,...) return s.SelectReleaseGroupEx(tp,...) end

		function Duel.SpecialSummon(tg,stype,sp,...) return s.SpecialSummon(tg,stype,tp,...) end
		function Duel.SpecialSummonStep(tg,stype,sp,...) return s.SpecialSummonStep(tg,stype,tp,...)end

		function Duel.SelectEffectYesNo(sp,...) return s.SelectEffectYesNo(tp,...) end
		function Duel.SelectYesNo(sp,desc) return s.SelectYesNo(tp,desc) end
		function Duel.SelectOption(sp,...) return s.SelectOption(tp,...) end
		function Duel.SelectPosition(sp,c,pos) return s.SelectPosition(tp,c,pos) end

		function Duel.AnnounceCoin(p,...) return s.AnnounceCoin(tp,...) end
		function Duel.AnnounceCard(p,...) return s.AnnounceCard(tp,...) end
		function Duel.AnnounceNumber(p,...) return s.AnnounceNumber(tp,...) end

		function Duel.Hint(htype,sp,desc) return s.Hint(htype,tp,desc) end
		function Duel.ConfirmCards(sp,tg) return s.ConfirmCards(tp,tg)end
		
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_PUBLIC)
		ge0:SetTargetRange(0,LOCATION_HAND)
		ge0:SetTarget(function() return s.Control_Mode end)
		Duel.RegisterEffect(ge0,tp)
		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_DECK+LOCATION_ONFIELD,nil),true)
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
		s.controltable={ge0,ge1,ge2,ge3}
		if not KOISHI_CHECK then return end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
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
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			tc.initial_effect(tc)
		end
	else
		Debug.Message("骇入结束")
		Group.Select=s.Select
		Group.FilterSelect=s.FilterSelect
		Group.SelectUnselect=s.SelectUnselect
		Card.RemoveOverlayCard=s.CRemoveOverlayCard
		Duel.SelectMatchingCard=s.SelectMatchingCard
		Duel.SelectReleaseGroup=s.SelectReleaseGroup
		Duel.SelectReleaseGroupEx=s.SelectReleaseGroupEx
		Duel.SelectTarget=s.SelectTarget
		Duel.SelectTribute=s.SelectTribute
		Duel.DiscardHand=s.DiscardHand
		Duel.RemoveOverlayCard=s.DRemoveOverlayCard
		Duel.SelectFusionMaterial=s.SelectFusionMaterial

		Duel.SpecialSummon=s.SpecialSummon
		Duel.SpecialSummonStep=s.SpecialSummonStep

		Duel.SelectEffectYesNo=s.SelectEffectYesNo
		Duel.SelectYesNo=s.SelectYesNo
		Duel.SelectOption=s.SelectOption
		Duel.SelectPosition=s.SelectPosition
		
		Duel.AnnounceCoin=s.AnnounceCoin
		Duel.AnnounceCard=s.AnnounceCard
		Duel.AnnounceNumber=s.AnnounceNumber

		Duel.ConfirmCards=s.ConfirmCards
		Duel.Hint=s.Hint
		
		
		for _,eff in ipairs(s.controltable) do
			eff:Reset()
		end
		s.controltable={}
	end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	s.SummonUnit=e:GetHandler()
	local res=s.SummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false)
	s.SummonUnit=nil
	return s.Control_Mode and tp~=e:GetHandler():GetOwner() and res
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
		if s.SummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
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
		if s.SummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
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
	if (s1 and s2 and Duel.SelectPosition(1-tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or (s1 and not s2) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		local zone=Duel.SelectField(1-tp,1,LOCATION_MZONE,LOCATION_MZONE,~s.sumzone(c,1-tp))
		if zone<0x10000 then
			Duel.Summon(tp,c,false,nil,0,zone)
		else
			Duel.Summon(tp,c,false,nil,0,zone/0x10000)
		end
	elseif s2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		local zone=Duel.SelectField(1-tp,1,LOCATION_MZONE,LOCATION_MZONE,~s.sumzone(c,1-tp))
		if zone<0x10000 then
			Duel.MSet(tp,c,false,nil,0,zone)
		else
			Duel.MSet(tp,c,false,nil,0,zone/0x10000)
		end
	end
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil) end
end
function s.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return s.Control_Mode and tp~=e:GetHandler():GetOwner() and (c:IsSpecialSummonable() or c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil) or c:IsLinkSummonable(nil))
end
function s.spactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=c:IsSpecialSummonable()	
	local s2=c:IsSynchroSummonable(nil)
	local s3=c:IsXyzSummonable(nil)
	local s4=c:IsLinkSummonable(nil)
	local op=0
	if s1 and not s2 and not s3 and not s4 then
		op=1
	else
		op=aux.SelectFromOptions(tp,{s2,1164},{s3,1165},{s4,1166})+1
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(1-tp,1,LOCATION_MZONE,LOCATION_MZONE,~s.spsumzone(c,1-tp))
	--zone limit
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(zone)
	Duel.RegisterEffect(e1,0)
	if op==1 then
		Duel.SpecialSummonRule(tp,c)
	elseif op==2 then
		Duel.SynchroSummon(tp,c,nil)
	elseif op==3 then
		Duel.XyzSummon(tp,c,nil)
	elseif op==4 then
		Duel.LinkSummon(tp,c,nil)
	end
	e1:Reset()
end
function s.sptarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if s.SpecialSummonUnit then
			return s.SpecialSummonUnit:IsSpecialSummonable() or s.SpecialSummonUnit:IsSynchroSummonable(nil) or s.SpecialSummonUnit:IsXyzSummonable(nil) or s.SpecialSummonUnit:IsLinkSummonable(nil)
		end
		return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) 
	end
end
function s.spsumzone(c,tp)
	local zone=0
	s.SpecialSummonUnit=c
	for i=0,4 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_USE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTargetRange(1,1)
		e1:SetValue((1<<i)*0x10000)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		if s.SpecialSummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
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
		if s.SpecialSummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
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
		if s.SpecialSummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
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
		if s.SpecialSummonCheckEffect[1-tp]:IsActivatable(1-tp,true,false) then
			zone=zone|0x400020
		end
		e1:Reset()
	end
	s.SpecialSummonUnit=nil
	return zone
end
function s.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local lpz=Duel.GetFieldCard(p,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_MONSTER)
	if #g==0 then return false end
	local pcon=aux.PendCondition()
	return s.Control_Mode and p~=e:GetHandler():GetOwner() and pcon(e,lpz,g)
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
	local pop=aux.PendOperation()
	pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
	e:Reset()
end
function s.addeffcost(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,...)
		local cost=effect:GetCost()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 then
			e:SetType(EFFECT_TYPE_ACTIVATE)
			if chk==0 then
				return (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tep,LOCATION_SZONE)>0 or c:IsLocation(LOCATION_SZONE) and c:IsFacedown()) and tp~=tep and (not cost or cost(e,tep,eg,ep,ev,re,r,rp,chk,...))
			else
				if c:IsLocation(LOCATION_SZONE) then Duel.ChangePosition(c,POS_FACEUP) end
				if c:IsLocation(LOCATION_HAND) then Duel.MoveToField(c,tp,tep,LOCATION_SZONE,POS_FACEUP,true) end
				if cost then cost(e,tep,eg,ep,ev,re,r,rp,chk,...) end
			end
		else
			if chk==0 then		   
				return (not cost or cost(e,tep,eg,ep,ev,re,r,rp,chk,...))
			else
				if cost then cost(e,tep,eg,ep,ev,re,r,rp,chk,...) end
			end
		end
	end
end
function s.addeffcon(effect,mp)
	return function (e,tp,...)
		local con=effect:GetCondition()
		local c=e:GetHandler()
		local tep=c:GetControler()
		return tp~=tep and (not con or con(e,tep,...)) 
	end
end
function s.addefftg(effect)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,...)
		local tg=effect:GetTarget()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if chk==0 then		   
			return (not tg or tg(e,tep,eg,ep,ev,re,r,rp,chk,...))
		else
			if tg then tg(e,tep,eg,ep,ev,re,r,rp,chk,...) end
		end
	end
end
function s.addeffop(effect)
	return function (e,tp,eg,ep,ev,...)
		local op=effect:GetOperation()
		local c=e:GetHandler()
		local tep=c:GetControler()
		if effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 and c:GetType()&(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP)==0 then e:GetHandler():CancelToGrave(false) end
		if op then op(e,tep,eg,ep,ev,...) end
	end
end
function s.change_effect(effect,c,mp)
	local eff=effect:Clone()
	local etype=EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_QUICK_O
	if effect:GetType()&etype~=0 then
		eff:SetDescription(aux.Stringid(id+1,9))			 
		eff:SetProperty(effect:GetProperty()|EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_EVENT_PLAYER)
		eff:SetCost(s.addeffcost(effect))
		eff:SetCondition(s.addeffcon(effect,mp))
		eff:SetTarget(s.addefftg(effect))
		eff:SetOperation(s.addeffop(effect)) 
		return eff
	elseif effect:GetType()&EFFECT_TYPE_ACTIVATE~=0 and not c:IsType(TYPE_MONSTER) then
		eff:SetDescription(aux.Stringid(id+1,9))
		if c and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_QUICKPLAY)) then 
			eff:SetType(EFFECT_TYPE_QUICK_O)
			eff:SetCode(EVENT_FREE_CHAIN)
		else
			eff:SetType(EFFECT_TYPE_IGNITION)
		end
		eff:SetRange(LOCATION_HAND+LOCATION_SZONE)
		eff:SetProperty(effect:GetProperty()|EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_EVENT_PLAYER)
		eff:SetCost(s.addeffcost(effect))
		eff:SetCondition(s.addeffcon(effect,mp))
		eff:SetTarget(s.addefftg(effect))
		eff:SetOperation(s.addeffop(effect)) 
		return eff
	else
		return 0
	end
end
function s.wildop()
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(g) do
		local og=tc:GetOverlayGroup()
		if #og>0 then g:Merge(og) end
	end
	s.Wild_Mode=not s.Wild_Mode
	if s.Wild_Mode then
		Debug.Message("歼灭模式 开")
		s.SetCountLimit=Effect.SetCountLimit
		function Effect.SetCountLimit(e,count,...)
			s.SetCountLimit(e,1,EFFECT_COUNT_CODE_CHAIN)
		end
		for tc in aux.Next(g) do
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			if tc.initial_effect then tc.initial_effect(tc) end
		end
		Effect.SetCountLimit=s.SetCountLimit
	else
		Debug.Message("歼灭模式 关")
		for tc in aux.Next(g) do
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			if tc.initial_effect then tc.initial_effect(tc) end
		end
	end
end
function s.randomop(tp)
	s.Random_Mode=not s.Random_Mode
	if s.Random_Mode then
		Debug.Message("灌铅骰子 开")
		function Group.RandomSelect(g,p,count)
			return s.Select(g,tp,count,count,nil)
		end
		function Duel.TossCoin(p,count)
			local ct={}
			if count==-1 then
				local i=1
				local coin=1
				while i<=20 and coin==1 do
					coin=1-s.AnnounceCoin(tp)
					table.insert(ct,coin)
					i=i+1
				end
				s.TossCoin(p,i)
				Duel.SetCoinResult(table.unpack(ct))
			else
				for i=1,count do 
					table.insert(ct,1-s.AnnounceCoin(tp)) 
				end
				s.TossCoin(p,count)
				Duel.SetCoinResult(table.unpack(ct))
			end
			return table.unpack(ct)
		end
		function Duel.TossDice(p,count)
			local ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
			return ac
		end
	else
		Debug.Message("灌铅骰子 关")
		Group.RandomSelect=s.RandomSelect
		Duel.TossCoin=s.TossCoin
		Duel.TossDice=s.TossDice
	end
end
function s.theworldop()
	s.Theworld_Mode=not s.Theworld_Mode
	if s.Theworld_Mode then
		Debug.Message("时间静止 开")
	else
		Debug.Message("时间静止 关")
		Duel.AdjustAll()
	end
end