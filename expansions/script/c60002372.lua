--双选模式启动
--Thanks to PurpleNightfall&SEINEctor Phan
local cm,m,o=GetID()
DuelModeChange=DuelModeChange or {}
DuelModeChange.loaded_metatable_list={}
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
if not cm.enable_all_setname then
	cm.enable_all_setname=true
	cm._is_set_card=Card.IsSetCard
	Card.IsSetCard=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_set_card(c,...)
	end
	cm._is_link_set_card=Card.IsLinkSetCard
	Card.IsLinkSetCard=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_set_card(c,...)
	end
	cm._is_fusion_set_card=Card.IsFusionSetCard
	Card.IsFusionSetCard=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_fusion_set_card(c,...)
	end
	cm._is_previous_set_card=Card.IsPreviousSetCard
	Card.IsPreviousSetCard=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_previous_set_card(c,...)
	end
	cm._is_original_set_card=Card.IsOriginalSetCard
	Card.IsOriginalSetCard=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_original_set_card(c,...)
	end
	cm._is_code=Card.IsCode
	Card.IsCode=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_code(c,...)
	end
	cm._is_original_code_rule=Card.IsOriginalCodeRule
	Card.IsOriginalCodeRule=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_original_code_rule(c,...)
	end
	cm._is_link_code=Card.IsLinkCode
	Card.IsLinkCode=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_code(c,...)
	end
	cm._is_fusion_code=Card.IsFusionCode
	Card.IsFusionCode=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_fusion_code(c,...)
	end
	cm._is_attribute=Card.IsAttribute
	Card.IsAttribute=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_attribute(c,...)
	end
	cm._is_fusion_attribute=Card.IsFusionAttribute
	Card.IsFusionAttribute=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_fusion_attribute(c,...)
	end
	cm._is_link_attribute=Card.IsLinkAttribute
	Card.IsLinkAttribute=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_attribute(c,...)
	end
	cm._is_attack=Card.IsAttack
	Card.IsAttack=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_attack(c,...)
	end
	cm._is_attack_above=Card.IsAttackAbove
	Card.IsAttackAbove=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_attack_above(c,...)
	end
	cm._is_attack_below=Card.IsAttackBelow
	Card.IsAttackBelow=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_attack_below(c,...)
	end
	cm._is_defence=Card.IsDefense
	Card.IsDefense=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_defence(c,...)
	end
	cm._is_defence_above=Card.IsDefenseAbove
	Card.IsDefenseAbove=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_defence_above(c,...)
	end
	cm._is_defence_below=Card.IsDefenseBelow
	Card.IsDefenseBelow=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_defence_below(c,...)
	end
	cm._is_race=Card.IsRace
	Card.IsRace=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_race(c,...)
	end
	cm._is_link_race=Card.IsLinkRace
	Card.IsLinkRace=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_race(c,...)
	end
	cm._is_level=Card.IsLevel
	Card.IsLevel=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_level(c,...)
	end
	cm._is_level_above=Card.IsLevelAbove
	Card.IsLevelAbove=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_level_above(c,...)
	end
	cm._is_level_below=Card.IsLevelBelow
	Card.IsLevelBelow=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_level_below(c,...)
	end
	cm._is_xyz_level=Card.IsXyzLevel
	Card.IsXyzLevel=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_xyz_level(c,...)
	end
	cm._is_rank=Card.IsRank
	Card.IsRank=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_rank(c,...)
	end
	cm._is_rank_above=Card.IsRankAbove
	Card.IsRankAbove=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_rank_above(c,...)
	end
	cm._is_rank_below=Card.IsRankBelow
	Card.IsRankBelow=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_rank_below(c,...)
	end
	cm._is_link=Card.IsLink
	Card.IsLink=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link(c,...)
	end
	cm._is_link_above=Card.IsLinkAbove
	Card.IsLinkAbove=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_above(c,...)
	end
	cm._is_link_below=Card.IsLinkBelow
	Card.IsLinkBelow=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_below(c,...)
	end
	cm._is_type=Card.IsType
	Card.IsType=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_type(c,...)
	end
	cm._is_fusion_type=Card.IsFusionType
	Card.IsFusionType=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_fusion_type(c,...)
	end
	cm._is_synchro_type=Card.IsSynchroType
	Card.IsSynchroType=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_synchro_type(c,...)
	end
	cm._is_xyz_type=Card.IsXyzType
	Card.IsXyzType=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_xyz_type(c,...)
	end
	cm._is_link_type=Card.IsLinkType
	Card.IsLinkType=function (c,...)
		return Duel.GetFlagEffect(tp,m)~=0 or cm._is_link_type(c,...)
	end
end
function cm.con(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	DuelModeChange.TwoPick1(tp)
		DuelModeChange.TwoPick1(1-tp)
	if Duel.GetFlagEffect(1-tp,m+10000000)==0 then
		Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1000)
	else
		DuelModeChange.TwoPick1(tp)
		DuelModeChange.TwoPick1(1-tp)
		
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
end


local A=1103515245
local B=12345
local M=1073741824
function DuelModeChange.TwoPick1(tp)
	DuelModeChange.DCard(tp)
	DuelModeChange.CreateCards(tp)
end
function DuelModeChange.DCard(tp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,0,nil)
	Debug.Message("正在删除原有卡片……")
	for i=1,g1:GetCount() do
		local dc=g1:GetFirst()
		Duel.Exile(dc,REASON_RULE)
		g1:RemoveCard(dc)
	end
end
function DuelModeChange.CreateCards(tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
	for u=1,30 do
		if not cm.r then
			cm.r=Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND):GetSum(Card.GetCode)
		end
		local g1=Group.CreateGroup()
		local g2=Group.CreateGroup()
		local ng1=Group.CreateGroup()
		local ng2=Group.CreateGroup()
		local ac=nil
		local _TGetID=GetID
		
			local tab1={}
			for i=1,4 do
				while not ac do
					local int=cm.roll(1,132000016)
					--continuously updated
					if int>132000000 and int<132000014 then int=int+739100000 end
					if int==132000014 then int=460524290 end
					if int==132000015 then int=978210027 end
					if int==132000016 then int=250000000 end
					
					local cc,ca,ctype=Duel.ReadCard(int,CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_TYPE)
					if cc then
						local dif=cc-ca
						local real=0
						if dif>-10 and dif<10 then
							real=ca
						else
							real=cc
						end
						if ctype&TYPE_TOKEN==0 and not cm.list(real) then
							ac=real
						end
					end
					
				end
				table.insert(tab1,ac)
				table.insert(cm.blacklist,ac)
				ac=nil
			end
			for i=1,4 do
				g1:AddCard(Duel.CreateToken(tp,tab1[i]))
			end
			if #g1>0 then
				local codes={}
				for tc in aux.Next(g1) do
					local code=tc:GetCode()
					table.insert(codes,code)
				end
				table.sort(codes)
				if aux.GetValueType(codes[1])=="number" then
					local afilter={codes[1],OPCODE_ISCODE}
					if #codes>1 then
						for i=2,#codes do
							table.insert(afilter,codes[i])
							table.insert(afilter,OPCODE_ISCODE)
							table.insert(afilter,OPCODE_OR)
						end
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
					Debug.Message("请选择需要的卡牌("..u.."/30)")
					local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
					if ac==tab1[1] or ac==tab1[2] then
						local gc1=Duel.CreateToken(tp,g1:GetFirst():GetCode())
						g1:RemoveCard(g1:GetFirst())
						local gc2=Duel.CreateToken(tp,g1:GetFirst():GetCode())
						Duel.SendtoDeck(gc1,tp,2,REASON_EFFECT)
						Duel.SendtoDeck(gc2,tp,2,REASON_EFFECT)
					else
						g1:RemoveCard(g1:GetFirst())
						g1:RemoveCard(g1:GetFirst())
						local gc1=Duel.CreateToken(tp,g1:GetFirst():GetCode())
						g1:RemoveCard(g1:GetFirst())
						local gc2=Duel.CreateToken(tp,g1:GetFirst():GetCode())
						Duel.SendtoDeck(gc1,tp,2,REASON_EFFECT)
						Duel.SendtoDeck(gc2,tp,2,REASON_EFFECT)
					end
				end
			end
		end
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,5,REASON_EFFECT)
end
cm.blacklist={} 
local _SelectMatchingCard=Duel.SelectMatchingCard
local _SelectReleaseGroup=Duel.SelectReleaseGroup
local _SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
local _SelectTarget=Duel.SelectTarget
local _SelectTribute=Duel.SelectTribute
local _DiscardHand=Duel.DiscardHand
local _DRemoveOverlayCard=Duel.RemoveOverlayCard
local _CRemoveOverlayCard=Card.RemoveOverlayCard
local _FilterSelect=Group.FilterSelect
local _Select=Group.Select
function cm.roll(min,max)
	min=tonumber(min)
	max=tonumber(max)
	cm.r=((cm.r*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(cm.r*min)+1
		else
			max=max-min+1
			return math.floor(cm.r*max+min)
		end
	end
	return cm.r
end
function cm.list(code)
	for _,codes in pairs(cm.blacklist) do
		if codes==code then return true end
	end
	return false
end