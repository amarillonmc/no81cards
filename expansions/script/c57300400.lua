--僵尸对战模式
local s,id,o=GetID()
function s.initial_effect(c)
	--Game Start
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.lmcon)
	e1:SetOperation(s.lmop)
	c:RegisterEffect(e1)
end
function s.lmcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFlagEffect(0,id)==0 and not c:IsPublic()
end
function s.lmop(e)
	if Duel.GetFlagEffect(0,id)~=0 then return end
	Duel.RegisterFlagEffect(0,id,0,0,1)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.ConfirmCards(tp,c)
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(24,0,aux.Stringid(id,1))
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		local g=Duel.GetFieldGroup(tp,0xff,0xff)
		for ec in aux.Next(g) do
			Duel.Exile(ec,0)
		end
		Duel.ResetTimeLimit(tp,900)
		Duel.ResetTimeLimit(1-tp,900)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		getmetatable(e:GetHandler()).announce_filter1={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter1))
		Duel.SetTargetParam(ac)
		getmetatable(e:GetHandler()).announce_filter2={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local bc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter2))
		getmetatable(e:GetHandler()).announce_filter3={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local cc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter3))
		getmetatable(e:GetHandler()).announce_filter4={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,cc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local dc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter4))
		getmetatable(e:GetHandler()).announce_filter5={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,cc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,dc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local ec=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter5))
		getmetatable(e:GetHandler()).announce_filter6={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,cc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,dc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ec,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local fc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter6))
		getmetatable(e:GetHandler()).announce_filter7={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,cc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,dc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ec,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,fc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local gc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter7))
		getmetatable(e:GetHandler()).announce_filter8={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,bc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,cc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,dc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ec,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,fc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,gc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local hc=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter8))
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,2))
		getmetatable(e:GetHandler()).announce_filter9={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local ic=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter9))
		Duel.SetTargetParam(ic)
		getmetatable(e:GetHandler()).announce_filter10={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local jc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter10))
		getmetatable(e:GetHandler()).announce_filter11={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local kc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter11))
		getmetatable(e:GetHandler()).announce_filter12={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,kc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local lc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter12))
		getmetatable(e:GetHandler()).announce_filter13={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,kc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,lc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local mc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter13))
		getmetatable(e:GetHandler()).announce_filter14={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,kc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,lc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,mc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local nc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter14))
		getmetatable(e:GetHandler()).announce_filter15={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,kc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,lc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,mc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,nc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local oc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter15))
		getmetatable(e:GetHandler()).announce_filter16={0xc520,OPCODE_ISSETCARD,57300401,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ic,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,jc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,kc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,lc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,mc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,nc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,oc,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		local pc=Duel.AnnounceCard(1-tp,table.unpack(getmetatable(e:GetHandler()).announce_filter16))
		--Load the data of the first player
		s.incremental(57300401,tp)
		s.incremental(ac,tp)
		s.incremental(bc,tp)
		s.incremental(cc,tp)
		s.incremental(dc,tp)
		s.incremental(ec,tp)
		s.incremental(fc,tp)
		s.incremental(gc,tp)
		s.incremental(hc,tp)
		s.incremental(57300411,tp)
		s.incremental(57300427,tp)
		s.incremental(57300431,tp)
		s.incremental(57300435,tp)
		s.incremental(57300436,tp)
		s.incremental(57300442,tp)
		s.incremental(57300443,tp)
		s.incremental(57300444,tp)
		s.incremental(57300449,tp)
		s.incremental(57300455,tp)
		--Loading data for backhanded players
		s.incremental(57300401,1-tp)
		s.incremental(ic,1-tp)
		s.incremental(jc,1-tp)
		s.incremental(kc,1-tp)
		s.incremental(lc,1-tp)
		s.incremental(mc,1-tp)
		s.incremental(nc,1-tp)
		s.incremental(oc,1-tp)
		s.incremental(pc,1-tp)
		s.incremental(57300411,1-tp)
		s.incremental(57300427,1-tp)
		s.incremental(57300431,1-tp)
		s.incremental(57300435,1-tp)
		s.incremental(57300436,1-tp)
		s.incremental(57300442,1-tp)
		s.incremental(57300443,1-tp)
		s.incremental(57300444,1-tp)
		s.incremental(57300449,1-tp)
		s.incremental(57300455,1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local pg1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if pg1:GetCount()>0 then
			Duel.SendtoHand(pg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,pg1)
		end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local pg2=Duel.SelectMatchingCard(1-tp,s.thfilter,1-tp,LOCATION_DECK,0,1,1,nil)
		if pg2:GetCount()>0 then
			Duel.SendtoHand(pg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,pg2)
		end
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		for p in aux.TurnPlayers() do
			local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
			if 5-ct>0 then
				if bk then
					bk=false
					Duel.BreakEffect()
				end
				Duel.Draw(p,5-ct,REASON_EFFECT)
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.drval)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(s.rmtg)
		e2:SetValue(LOCATION_DECK)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetValue(0)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(0,id,0,0,1)
	end
end
function s.incremental(code,tp)
	local tn=s.calculation(code)
	if tn==3 then
		local x=0
		while x<3 do
			local token=Duel.CreateToken(tp,code)
			Duel.SendtoDeck(token,nil,0,0)
			x=x+1
		end
	elseif tn==2 then
		local x=0
		while x<2 do
			local token=Duel.CreateToken(tp,code)
			Duel.SendtoDeck(token,nil,0,0)
			x=x+1
		end
	else
		local token=Duel.CreateToken(tp,code)
		Duel.SendtoDeck(token,nil,0,0)
	end
end
function s.calculation(code)
	local token=Duel.CreateToken(tp,code)
	if token:IsType(TYPE_SPELL+TYPE_TRAP) or token:IsLevelBelow(5)
		or token:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
		return 3
	elseif token:IsLevelAbove(6) and token:IsLevelBelow(9) then
		return 2
	else
		return 1
	end
end
function s.thfilter(c)
	return c:IsCode(57300401) and c:IsAbleToHand()
end
function s.drval(e)
	local tp=Duel.GetTurnPlayer()
	local ct=5-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)
	if ct>=1 then
		return ct
	else
		return 1
	end
end
function s.rmtg(e,c)
	return c:IsSetCard(0xc520)
end
function s.rrmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function s.rrmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local rt=0
	for i=1,ct do
		if Duel.GetDecktopGroup(tp,i)==i then rt=rt+1 end
	end
	local tg=Duel.GetDecktopGroup(tp,rt)
	if #tg==0 then return end
	Duel.DisableShuffleCheck()
	if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)>0 and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)==0 then
		Duel.Win(1-tp,WIN_REASON_EXODIA)
	end
end
function Zombie_Characteristics(c,lp)
	local ce0=Effect.CreateEffect(c)
	ce0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ce0:SetCode(EVENT_BATTLED)
	ce0:SetCondition(s.damcon)
	ce0:SetOperation(s.damop)
	c:RegisterEffect(ce0)
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_FIELD)
	ce1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	ce1:SetRange(LOCATION_MZONE)
	ce1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce1:SetTarget(s.indtg)
	ce1:SetValue(1)
	c:RegisterEffect(ce1)
	local ce2=Effect.CreateEffect(c)
	ce2:SetType(EFFECT_TYPE_FIELD)
	ce2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce2:SetValue(s.tglimit)
	c:RegisterEffect(ce2)
	local ce3=Effect.CreateEffect(c)
	ce3:SetType(EFFECT_TYPE_SINGLE)
	ce3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce3:SetRange(LOCATION_MZONE)
	ce3:SetCode(EFFECT_SELF_DESTROY)
	ce3:SetCondition(s.descon)
	c:RegisterEffect(ce3)
	local ce4=Effect.CreateEffect(c)
	ce4:SetType(EFFECT_TYPE_SINGLE)
	ce4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce4:SetCode(EFFECT_UNRELEASABLE_SUM)
	ce4:SetRange(LOCATION_MZONE)
	ce4:SetLabel(lp)
	ce4:SetValue(1)
	ce4:SetCondition(s.imcon)
	c:RegisterEffect(ce4)
	local ce5=ce4:Clone()
	ce5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	ce5:SetValue(s.fuslimit)
	c:RegisterEffect(ce5)
	local ce6=ce4:Clone()
	ce6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(ce6)
	local ce7=ce4:Clone()
	ce7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(ce7)
	local ce8=Effect.CreateEffect(c)
	ce8:SetType(EFFECT_TYPE_SINGLE)
	ce8:SetCode(EFFECT_SELF_DESTROY)
	ce8:SetRange(LOCATION_MZONE)
	ce8:SetLabel(lp)
	ce8:SetCondition(s.descon2)
	c:RegisterEffect(ce8)
	local ce9=Effect.CreateEffect(c)
	ce9:SetType(EFFECT_TYPE_SINGLE)
	ce9:SetCode(EFFECT_SET_ATTACK_FINAL)
	ce9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce9:SetRange(LOCATION_MZONE)
	ce9:SetLabel(lp)
	ce9:SetValue(s.adval)
	c:RegisterEffect(ce9)
end
function Zombie_Characteristics_X(c)
	local ce0=Effect.CreateEffect(c)
	ce0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ce0:SetCode(EVENT_BATTLED)
	ce0:SetCondition(s.damcon)
	ce0:SetOperation(s.damop)
	c:RegisterEffect(ce0)
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_FIELD)
	ce1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	ce1:SetRange(LOCATION_MZONE)
	ce1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce1:SetTarget(s.indtg)
	ce1:SetValue(1)
	c:RegisterEffect(ce1)
	local ce2=Effect.CreateEffect(c)
	ce2:SetType(EFFECT_TYPE_FIELD)
	ce2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce2:SetValue(s.tglimit)
	c:RegisterEffect(ce2)
	local ce3=Effect.CreateEffect(c)
	ce3:SetType(EFFECT_TYPE_SINGLE)
	ce3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce3:SetRange(LOCATION_MZONE)
	ce3:SetCode(EFFECT_SELF_DESTROY)
	ce3:SetCondition(s.descon)
	c:RegisterEffect(ce3)
end
function Zombie_Characteristics_EX(c,lp)
	local ce0=Effect.CreateEffect(c)
	ce0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ce0:SetCode(EVENT_BATTLED)
	ce0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ce0:SetCondition(s.damcon)
	ce0:SetOperation(s.damop)
	c:RegisterEffect(ce0)
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_FIELD)
	ce1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	ce1:SetRange(LOCATION_MZONE)
	ce1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce1:SetTarget(s.indtg)
	ce1:SetValue(1)
	c:RegisterEffect(ce1)
	local ce2=Effect.CreateEffect(c)
	ce2:SetType(EFFECT_TYPE_FIELD)
	ce2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ce2:SetValue(s.tglimit)
	c:RegisterEffect(ce2)
	local ce3=Effect.CreateEffect(c)
	ce3:SetType(EFFECT_TYPE_SINGLE)
	ce3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce3:SetRange(LOCATION_MZONE)
	ce3:SetCode(EFFECT_SELF_DESTROY)
	ce3:SetCondition(s.descon)
	c:RegisterEffect(ce3)
	local ce4=Effect.CreateEffect(c)
	ce4:SetType(EFFECT_TYPE_SINGLE)
	ce4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce4:SetCode(EFFECT_UNRELEASABLE_SUM)
	ce4:SetRange(LOCATION_MZONE)
	ce4:SetLabel(lp)
	ce4:SetValue(1)
	ce4:SetCondition(s.imcon)
	c:RegisterEffect(ce4)
	local ce5=ce4:Clone()
	ce5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	ce5:SetValue(s.fuslimit)
	c:RegisterEffect(ce5)
	local ce6=ce4:Clone()
	ce6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(ce6)
	local ce7=ce4:Clone()
	ce7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(ce7)
	local ce8=Effect.CreateEffect(c)
	ce8:SetType(EFFECT_FLAG_SINGLE_RANGE)
	ce8:SetCode(EFFECT_SELF_DESTROY)
	ce8:SetRange(LOCATION_MZONE)
	ce8:SetLabel(lp)
	ce8:SetCondition(s.descon2)
	c:RegisterEffect(ce8)
	local ce9=Effect.CreateEffect(c)
	ce9:SetType(EFFECT_TYPE_SINGLE)
	ce9:SetCode(EFFECT_CANNOT_TRIGGER)
	ce9:SetRange(LOCATION_MZONE)
	ce9:SetLabel(lp)
	ce9:SetCondition(s.imcon)
	c:RegisterEffect(ce9)
	local ce10=Effect.CreateEffect(c)
	ce10:SetType(EFFECT_TYPE_SINGLE)
	ce10:SetCode(EFFECT_SET_ATTACK_FINAL)
	ce10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce10:SetRange(LOCATION_MZONE)
	ce10:SetLabel(lp)
	ce10:SetValue(s.adval)
	c:RegisterEffect(ce10)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	return Duel.GetAttacker()==c
		and ((c:IsPosition(POS_ATTACK) and bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK))
		or bc==nil and Duel.GetFlagEffect(0,id)==0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	local aatk=0
	if c:IsPosition(POS_ATTACK) then
		aatk=c:GetAttack()*-1
	end
	local batk=0
	if bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK) then
		batk=bc:GetAttack()*-1
	end
	if bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK) and c:GetFlagEffect(57300424)==0 then
		local e1=Effect.CreateEffect(bc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(batk)
		c:RegisterEffect(e1)
	end
	if bc and c:IsPosition(POS_ATTACK) and bc:GetFlagEffect(57300424)==0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(aatk)
		bc:RegisterEffect(e1)
	end
	if bc==nil and c:GetAttack()>0 and Duel.GetFlagEffect(0,id)~=0 then
		local dam=math.ceil(c:GetAttack()/1000)
		if dam>0 then
			local rt=0
			for i=1,dam do
				if Duel.GetDecktopGroup(1-tp,i):GetCount()==i then rt=rt+1 end
			end
			local tg=Duel.GetDecktopGroup(1-tp,rt)
			if #tg==0 then return end
			Duel.DisableShuffleCheck()
			if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)>0 and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_DECK,nil)==0 then
				Duel.Win(tp,WIN_REASON_EXODIA)
			end
		end
	end
end
function s.indtg(e,c)
	local tc=e:GetHandler()
	return (c==tc  and tc:GetBattleTarget():IsSetCard(0xc520) or c==tc:GetBattleTarget() and tc:IsSetCard(0xc520))
end
function s.tglimit(e,c)
	local tc=e:GetHandler()
	return (c==tc  and tc:GetBattleTarget():IsSetCard(0xc520) or c==tc:GetBattleTarget() and tc:IsSetCard(0xc520))
end
function s.descon(e)
	local c=e:GetHandler()
	return c:GetDefense()==0
end
function s.imcon(e)
	local c=e:GetHandler()
	return c:IsDefenseBelow(e:GetLabel())
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.descon2(e)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer() and Duel.GetCurrentPhase()==PHASE_END and c:GetDefense()<=e:GetLabel()
end
function s.adval(e,c)
	if c:IsDefenseBelow(e:GetLabel()) then
		return 0
	else
		return c:GetAttack()
	end
end