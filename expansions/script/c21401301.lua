--超化形兽 碳水双面兽
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290
local CARD_CARBON_CRAB=21401292
local CARD_OXYGEN_BULL=21401294

local MAT_H=0x1
local MAT_C=0x2
local MAT_O=0x4
local REQ_CARBOHYDRATE=MAT_H|MAT_C|MAT_O

local EFFECT_METAFORM_FUSION_SUB=0x9D710100

function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)

	s.add_metafusion_proc(c,REQ_CARBOHYDRATE,true,false,CARD_HYDROGEN_EAGLE,CARD_CARBON_CRAB,CARD_OXYGEN_BULL)

	aux.AddContactFusionProcedure(c,s.contact_filter,LOCATION_ONFIELD,0,s.contact_op)

	s.add_metafusion_sub(c,REQ_CARBOHYDRATE)

	--② 自己·对方回合，解放自身，最多盖放3张卡名不同的「化形兽」魔陷
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)

	--③ 墓地除外，手卡·额外卡组表侧特召1只「化形兽」怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

--==============================
-- 自定义融合素材系统
--==============================
function s.add_metafusion_proc(c,req,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local listed={...}
	local mat={}
	for _,code in ipairs(listed) do
		mat[code]=true
		aux.AddCodeList(c,code)
	end

	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={1,s.req_count(req)}
	end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(s.fuscon(req,sub,insf))
	e1:SetOperation(s.fusop(req,sub,insf))
	c:RegisterEffect(e1)
end

function s.req_count(req)
	local ct=0
	if (req&MAT_H)~=0 then ct=ct+1 end
	if (req&MAT_C)~=0 then ct=ct+1 end
	if (req&MAT_O)~=0 then ct=ct+1 end
	return ct
end

function s.regular_mask(c)
	local m=0
	if c:IsFusionCode(CARD_HYDROGEN_EAGLE) then m=m|MAT_H end
	if c:IsFusionCode(CARD_CARBON_CRAB) then m=m|MAT_C end
	if c:IsFusionCode(CARD_OXYGEN_BULL) then m=m|MAT_O end
	return m
end

function s.meta_mask(c,fc,req)
	local m=s.regular_mask(c)&req

	if fc:IsSetCard(SET_METAFORM) and fc:IsType(TYPE_FUSION) then
		local effs={c:IsHasEffect(EFFECT_METAFORM_FUSION_SUB)}
		for _,te in ipairs(effs) do
			m=m|(te:GetValue()&req)
		end
	end
	return m&req
end

function s.mat_filter(c,fc,summon_type,req,allow_sub,notfusion)
	if notfusion then
		return c:IsLocation(LOCATION_ONFIELD)
			and c:IsControler(fc:GetControler())
			and c:IsReleasable(REASON_COST+REASON_MATERIAL)
			and s.meta_mask(c,fc,req)>0
	end

	return c:IsCanBeFusionMaterial(fc,summon_type)
		and not c:IsHasEffect(6205579)
		and (
			s.meta_mask(c,fc,req)>0
			or (allow_sub and c:CheckFusionSubstitute(fc))
		)
end

function s.fuscon(req,sub,insf)
	return function(e,g,gc,chkfnf)
		if g==nil then
			return insf and aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL)
		end
		local fc=e:GetHandler()
		local tp=fc:GetControler()
		chkfnf=chkfnf or tp

		local hexsealed=(chkfnf&0x100)~=0
		local notfusion=(chkfnf&0x200)~=0
		local allow_sub=(sub or hexsealed) and not notfusion
		local summon_type=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION

		local mg=g:Filter(s.mat_filter,nil,fc,summon_type,req,allow_sub,notfusion)
		if gc then
			if not mg:IsContains(gc) then return false end
			Duel.SetSelectedCard(gc)
		end
		return mg:CheckSubGroup(s.fusion_goal,1,s.req_count(req),tp,fc,req,chkfnf,allow_sub)
	end
end

function s.fusop(req,sub,insf)
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local fc=e:GetHandler()
		chkfnf=chkfnf or tp

		local hexsealed=(chkfnf&0x100)~=0
		local notfusion=(chkfnf&0x200)~=0
		local allow_sub=(sub or hexsealed) and not notfusion
		local summon_type=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
		local cancel=notfusion and Duel.GetCurrentChain()==0

		local mg=eg:Filter(s.mat_filter,nil,fc,summon_type,req,allow_sub,notfusion)
		if gc then
			Duel.SetSelectedCard(gc)
		end

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:SelectSubGroup(tp,s.fusion_goal,cancel,1,s.req_count(req),tp,fc,req,chkfnf,allow_sub)
		if sg then
			Duel.SetFusionMaterial(sg)
		else
			Duel.SetFusionMaterial(Group.CreateGroup())
		end
	end
end

function s.fusion_goal(sg,tp,fc,req,chkfnf,allow_sub)
	local chkf=chkfnf&0xff
	local not_fusion=(chkfnf&(0x100|0x200))~=0

	if not not_fusion and sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then
		return false
	end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then
		return false
	end
	if chkf~=PLAYER_NONE and Duel.GetLocationCountFromEx(tp,tp,sg,fc)<=0 then
		return false
	end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then
		return false
	end
	if aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then
		return false
	end

	return s.meta_goal(sg,fc,req)
		or s.normal_sub_goal(sg,fc,req,allow_sub)
end

function s.meta_goal(sg,fc,req)
	local masks={}
	for tc in aux.Next(sg) do
		local m=s.meta_mask(tc,fc,req)
		if m==0 then return false end
		table.insert(masks,m)
	end

	if #masks>s.req_count(req) then return false end

	return s.meta_assign(masks,1,req)
end

function s.meta_assign(masks,idx,remain)
	if idx>#masks then
		return remain==0
	end

	local can=masks[idx]&remain
	if can==0 then return false end

	local sub=can
	while sub>0 do
		if s.meta_assign(masks,idx+1,remain-sub) then
			return true
		end
		sub=(sub-1)&can
	end
	return false
end

function s.normal_sub_goal(sg,fc,req,allow_sub)
	if not allow_sub then return false end
	if sg:GetCount()~=s.req_count(req) then return false end

	for subc in aux.Next(sg) do
		if subc:CheckFusionSubstitute(fc) and not subc:IsHasEffect(6205579) then
			local regular=0
			local ok=true
			for tc in aux.Next(sg) do
				if tc~=subc then
					local m=s.regular_mask(tc)&req
					if m==0 then
						ok=false
						break
					end
					regular=regular|m
				end
			end
			if ok then
				for _,bit in ipairs({MAT_H,MAT_C,MAT_O}) do
					if (req&bit)~=0 then
						local need=req-bit
						if (regular&need)==need then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

--==============================
-- 接触融合
--==============================
function s.contact_filter(c,fc)
	return c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(fc:GetControler())
		and c:IsReleasable(REASON_COST+REASON_MATERIAL)
		and s.meta_mask(c,fc,REQ_CARBOHYDRATE)>0
end

function s.contact_op(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end

--==============================
-- ① 素材代替
--==============================
function s.add_metafusion_sub(c,mask)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_METAFORM_FUSION_SUB)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(mask)
	c:RegisterEffect(e1)
end

--==============================
-- ② 盖放最多3张卡名不同的「化形兽」魔陷
-- 场地魔法使用场地区，不占普通魔法·陷阱区空位
--==============================
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.setfilter(c)
	return c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsSSetable()
end

function s.szone_count(tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct<0 then ct=0 end
	return ct
end

function s.fzone_count(tp)
	return Duel.CheckLocation(tp,LOCATION_FZONE,0) and 1 or 0
end

function s.set_available_count(tp)
	return s.szone_count(tp)+s.fzone_count(tp)
end

function s.setcheck(g,tp)
	if g:GetClassCount(Card.GetCode)~=g:GetCount() then return false end

	local szct=0
	local fzct=0
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_FIELD) then
			fzct=fzct+1
		else
			szct=szct+1
		end
	end

	return szct<=s.szone_count(tp)
		and fzct<=s.fzone_count(tp)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.min(3,s.set_available_count(tp))
	if chk==0 then
		if ct<=0 then return false end
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(s.setcheck,1,ct,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_DECK)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(3,s.set_available_count(tp))
	if ct<=0 then return end

	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end
	if not g:CheckSubGroup(s.setcheck,1,ct,tp) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,s.setcheck,false,1,ct,tp)
	if sg and #sg>0 then
		Duel.SSet(tp,sg)
	end
end

--==============================
-- ③ 墓地除外，特召「化形兽」怪兽
--==============================
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.spfilter(c,e,tp)
	if not c:IsSetCard(SET_METAFORM) then return false end
	if not c:IsType(TYPE_MONSTER) then return false end
	if c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup() then return false end
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end

	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	if #g==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end

	if tc:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	end

	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
