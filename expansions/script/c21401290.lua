--化形兽 氢素鹰
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290
local CARD_MANAGER=21401291
local CARD_CARBON_CRAB=21401292
local CARD_OXYGEN_BULL=21401294

local ADD_H_DESTROY=1
local ADD_H_SPSPELL=2

local METAFORM_EVENT_ADD=(EVENT_CUSTOM or 0x30000000)+0x9D71

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,CARD_HYDROGEN_EAGLE)

	--P①: FIRE monster Normal/Special Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--M①: opponent's turn, listed card leaves your field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.moncon)
	e3:SetTarget(s.montg)
	e3:SetOperation(s.monop)
	c:RegisterEffect(e3)
end

--==============================
-- Additional-effect manager
-- H/C/O 三张共用，通过 _G 共享数据
-- 每次融合怪兽特殊召唤成功时，在那只融合怪兽身上 CreateEffect
-- 再注册为玩家可发动效果，并手动 RaiseEvent
--==============================
function s.get_add_manager()
	if not _G.METAFORM_ADD_MANAGER then
		_G.METAFORM_ADD_MANAGER={
			pool={[0]={},[1]={}},
			opt_seq=0,
			event_seq=0,
			temp_seq=0,
			events={},
			temp={}
		}
	end
	local mgr=_G.METAFORM_ADD_MANAGER
	if not mgr.pool then mgr.pool={[0]={},[1]={}} end
	if not mgr.opt_seq then mgr.opt_seq=0 end
	if not mgr.event_seq then mgr.event_seq=0 end
	if not mgr.temp_seq then mgr.temp_seq=0 end
	if not mgr.events then mgr.events={} end
	if not mgr.temp then mgr.temp={} end
	return mgr
end

function s.prune_pool()
	local mgr=s.get_add_manager()
	local turn=Duel.GetTurnCount()
	for p=0,1 do
		local np={}
		for _,opt in ipairs(mgr.pool[p] or {}) do
			if opt.turn==turn then
				table.insert(np,opt)
			end
		end
		mgr.pool[p]=np
	end
	for k,v in pairs(mgr.events) do
		if v.turn~=turn then
			mgr.events[k]=nil
		end
	end
	for k,v in pairs(mgr.temp) do
		if v.turn~=turn then
			mgr.temp[k]=nil
		end
	end
end

function s.ensure_add_watcher(c)
	if not _G.METAFORM_ADD_FUNCS then
		_G.METAFORM_ADD_FUNCS={
			watcher_op=s.add_watcher_op,
			trigger_tg=s.add_trigger_tg,
			trigger_op=s.add_trigger_op
		}
	end
	if Duel.GetFlagEffect(0,CARD_MANAGER+0x100)>0 then return end

	local funcs=_G.METAFORM_ADD_FUNCS
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge:SetOperation(funcs.watcher_op)
	Duel.RegisterEffect(ge,0)

	Duel.RegisterFlagEffect(0,CARD_MANAGER+0x100,0,0,1)
end

function s.register_add_option(tp,code,effid,desc,chk,tg,op,source_card)
	s.ensure_add_watcher(source_card)
	s.prune_pool()

	local mgr=s.get_add_manager()
	mgr.opt_seq=mgr.opt_seq+1

	table.insert(mgr.pool[tp],{
		uid=mgr.opt_seq,
		code=code,
		effid=effid,
		desc=desc,
		chk=chk,
		tg=tg,
		op=op,
		source_card=source_card,
		source_code=source_card:GetOriginalCode(),
		turn=Duel.GetTurnCount()
	})
end

function s.add_basic_fusion_filter(c,tp)
	return c:IsControler(tp)
		and c:IsFaceup()
		and c:IsType(TYPE_FUSION)
end

function s.get_add_event(event_id)
	local mgr=s.get_add_manager()
	local evinfo=mgr.events[event_id]
	if not evinfo then return nil end
	if evinfo.turn~=Duel.GetTurnCount() then return nil end
	return evinfo
end

function s.get_add_option(tp,uid)
	local mgr=s.get_add_manager()
	for _,opt in ipairs(mgr.pool[tp] or {}) do
		if opt.uid==uid and opt.turn==Duel.GetTurnCount() then
			return opt
		end
	end
	return nil
end

function s.get_available_add_options(e,tp,fc,event_id)
	local mgr=s.get_add_manager()
	local evinfo=s.get_add_event(event_id)
	local opts={}
	if not evinfo or not fc then return opts end

	for _,opt in ipairs(mgr.pool[tp] or {}) do
		if opt.turn==Duel.GetTurnCount()
			and not evinfo.used[tp][opt.uid]
			and aux.IsCodeListed(fc,opt.code)
			and opt.chk(e,tp,opt.source_card,fc) then
			table.insert(opts,opt)
		end
	end
	return opts
end

function s.add_watcher_op(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	s.prune_pool()

	local mgr=s.get_add_manager()
	local has_pool=false
	for p=0,1 do
		if mgr.pool[p] and #mgr.pool[p]>0 then
			has_pool=true
			break
		end
	end
	if not has_pool then return end

	mgr.event_seq=mgr.event_seq+1
	local event_id=mgr.event_seq
	mgr.events[event_id]={
		turn=Duel.GetTurnCount(),
		used={[0]={},[1]={}}
	}

	local created=false
	for p=0,1 do
		if mgr.pool[p] and #mgr.pool[p]>0 then
			local fg=eg:Filter(s.add_basic_fusion_filter,nil,p)
			local rg=Group.CreateGroup()

			for fc in aux.Next(fg) do
				local dummy=Effect.CreateEffect(fc)
				local opts=s.get_available_add_options(dummy,p,fc,event_id)
				if #opts>0 then
					s.create_temp_add_effects(p,fc,event_id,#opts)
					rg:AddCard(fc)
					created=true
				end
			end

			if rg:GetCount()>0 then
				Duel.RaiseEvent(rg,METAFORM_EVENT_ADD,e,0,0,p,event_id)
			end
		end
	end

	if not created then
		mgr.events[event_id]=nil
	end
end

function s.create_temp_add_effects(tp,fc,event_id,ct)
	local mgr=s.get_add_manager()

	local dummy=Effect.CreateEffect(fc)
	local opts=s.get_available_add_options(dummy,tp,fc,event_id)
	for _,opt in ipairs(opts) do
		if fc:GetFlagEffect(CARD_MANAGER+opt.effid)==0 then
			fc:RegisterFlagEffect(
				CARD_MANAGER+opt.effid,
				RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,
				EFFECT_FLAG_CLIENT_HINT,
				1,
				0,
				opt.desc
			)
		end
	end

	for i=1,ct do
		mgr.temp_seq=mgr.temp_seq+1
		local tid=mgr.temp_seq

		mgr.temp[tid]={
			event_id=event_id,
			tp=tp,
			fc=fc,
			turn=Duel.GetTurnCount(),
			chosen_uid=0
		}

		local e1=Effect.CreateEffect(fc)
		e1:SetDescription(aux.Stringid(CARD_MANAGER,7))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(METAFORM_EVENT_ADD)
		e1:SetLabel(tid)
		e1:SetTarget(s.add_trigger_tg)
		e1:SetOperation(s.add_trigger_op)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.get_temp_info(e,ev,eg)
	local mgr=s.get_add_manager()
	local info=mgr.temp[e:GetLabel()]
	if not info then return nil end
	if info.turn~=Duel.GetTurnCount() then return nil end
	if ev and info.event_id~=ev then return nil end
	if eg and info.fc and not eg:IsContains(info.fc) then return nil end
	return info
end

function s.add_trigger_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local info=s.get_temp_info(e,ev,eg)
	if chk==0 then
		return info
			and info.tp==tp
			and #s.get_available_add_options(e,tp,info.fc,info.event_id)>0
	end

	if not info or info.tp~=tp then return end
	local opts=s.get_available_add_options(e,tp,info.fc,info.event_id)
	if #opts==0 then return end

	local descs={}
	for _,opt in ipairs(opts) do
		table.insert(descs,opt.desc)
	end

	local sel=0
	if #opts>1 then
		sel=Duel.SelectOption(tp,table.unpack(descs))
	end
	local opt=opts[sel+1]
	if not opt then return end

	local evinfo=s.get_add_event(info.event_id)
	if not evinfo then return end

	evinfo.used[tp][opt.uid]=true
	info.chosen_uid=opt.uid

	if opt.tg then
		opt.tg(e,tp,opt.source_card,info.fc)
	end
end

function s.add_trigger_op(e,tp,eg,ep,ev,re,r,rp)
	local info=s.get_temp_info(e,nil,nil)
	if not info or info.tp~=tp or info.chosen_uid==0 then return end

	local opt=s.get_add_option(tp,info.chosen_uid)
	if not opt then return end

	Duel.Hint(HINT_CARD,0,opt.source_code or opt.source_card:GetOriginalCode())
	Duel.Hint(HINT_OPSELECTED,1-tp,opt.desc)

	opt.op(e,tp,opt.source_card,info.fc)
end

--==============================
-- Pendulum effect
--==============================
function s.firefilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.firefilter,1,nil)
end

function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.pend_core_check(e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end

function s.penop(e,tp,eg,ep,ev,re,r,rp)
	s.pend_core_op(e,tp)
end

function s.pend_core_check(e,tp)
	local c=e:GetHandler()
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end

function s.pend_core_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not s.pend_core_check(e,tp) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end

	local b1=s.h_destroy_chk(e,tp,c,nil)
	local b2=s.h_spspell_chk(e,tp,c,nil)
	if not b1 and not b2 then return end

	local op
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(CARD_MANAGER,0),aux.Stringid(CARD_MANAGER,1))
	elseif b1 then
		op=0
	else
		op=1
	end

	if op==0 then
		s.register_add_option(tp,CARD_HYDROGEN_EAGLE,ADD_H_SPSPELL,
			aux.Stringid(CARD_MANAGER,1),s.h_spspell_chk,s.h_spspell_tg,s.h_spspell_op,c)
		s.h_destroy_op(e,tp,c,nil)
	else
		s.register_add_option(tp,CARD_HYDROGEN_EAGLE,ADD_H_DESTROY,
			aux.Stringid(CARD_MANAGER,0),s.h_destroy_chk,s.h_destroy_tg,s.h_destroy_op,c)
		s.h_spspell_op(e,tp,c,nil)
	end
end

--==============================
-- Additional option A: destroy 1 card
--==============================
function s.desfilter(c,e)
	return c:IsDestructable() and not c:IsImmuneToEffect(e)
end

function s.h_destroy_chk(e,tp,source,fc)
	return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e)
end

function s.h_destroy_tg(e,tp,source,fc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end

function s.h_destroy_op(e,tp,source,fc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--==============================
-- Additional option B: S/T from Deck becomes Normal Monster
--==============================
function s.listed_metacodes(c)
	local t={}
	if aux.IsCodeListed(c,CARD_HYDROGEN_EAGLE) then table.insert(t,CARD_HYDROGEN_EAGLE) end
	if aux.IsCodeListed(c,CARD_CARBON_CRAB) then table.insert(t,CARD_CARBON_CRAB) end
	if aux.IsCodeListed(c,CARD_OXYGEN_BULL) then table.insert(t,CARD_OXYGEN_BULL) end
	return t
end

function s.can_sp_as_stmonster(c,e,tp,code)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(
			tp,code,SET_METAFORM,TYPE_MONSTER+TYPE_NORMAL,
			1400,700,4,RACE_WINDBEAST,ATTRIBUTE_FIRE)
end

function s.stmonster_filter(c,e,tp)
	if not c:IsType(TYPE_SPELL+TYPE_TRAP) then return false end
	local codes=s.listed_metacodes(c)
	if #codes==0 then return false end
	for _,code in ipairs(codes) do
		if s.can_sp_as_stmonster(c,e,tp,code) then return true end
	end
	return false
end

function s.h_spspell_chk(e,tp,source,fc)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.stmonster_filter,tp,LOCATION_DECK,0,1,nil,e,tp)
end

function s.h_spspell_tg(e,tp,source,fc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.h_spspell_op(e,tp,source,fc)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.stmonster_filter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end

	local codes=s.listed_metacodes(tc)
	local available={}
	for _,code in ipairs(codes) do
		if s.can_sp_as_stmonster(tc,e,tp,code) then
			table.insert(available,code)
		end
	end
	if #available==0 then return end

	local code=available[1]
	if #available>1 then
		code=Duel.AnnounceCard(tp,table.unpack(available))
	end
	if not s.can_sp_as_stmonster(tc,e,tp,code) then return end

	tc:AddMonsterAttribute(TYPE_NORMAL)
	if not Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then return end
	s.register_stmonster_effects(tc,code)
	Duel.SpecialSummonComplete()
end

function s.register_stmonster_effects(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(code)
	c:RegisterEffect(e2,true)

	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_WINDBEAST)
	c:RegisterEffect(e3,true)

	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e4,true)

	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(4)
	c:RegisterEffect(e5,true)

	local e6=e1:Clone()
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetValue(1400)
	c:RegisterEffect(e6,true)

	local e7=e1:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(700)
	c:RegisterEffect(e7,true)
end

--==============================
-- Monster effect
--==============================
function s.leavefilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and aux.IsCodeListed(c,CARD_HYDROGEN_EAGLE)
end

function s.moncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp
		and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
		and not eg:IsContains(c)
		and eg:IsExists(s.leavefilter,1,nil,tp)
end

function s.place_check(e,tp)
	local c=e:GetHandler()
	return c:IsRelateToEffect(e)
		and not c:IsForbidden()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end

function s.montg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.pend_core_check(e,tp) or s.place_check(e,tp)
	end
	if s.pend_core_check(e,tp) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,e:GetHandler():GetLocation())
	end
end

function s.monop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=s.pend_core_check(e,tp)
	local b2=s.place_check(e,tp)
	if not b1 and not b2 then return end

	local op
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
	elseif b1 then
		op=0
	else
		op=1
	end

	if op==0 then
		s.pend_core_op(e,tp,eg,ep,ev,re,r,rp)
	else
		if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
