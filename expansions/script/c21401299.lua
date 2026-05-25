--进化形兽 过氧蛇龙
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290
local CARD_CARBON_CRAB=21401292
local CARD_OXYGEN_BULL=21401294

local MAT_H=0x1
local MAT_C=0x2
local MAT_O=0x4
local REQ_PEROXIDE=MAT_H|MAT_O

local EFFECT_METAFORM_FUSION_SUB=0x9D710100

function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)

	s.add_metafusion_proc(c,REQ_PEROXIDE,true,false,CARD_HYDROGEN_EAGLE,CARD_OXYGEN_BULL)

	aux.AddContactFusionProcedure(c,s.contact_filter,LOCATION_ONFIELD,0,s.contact_op)

	s.add_metafusion_sub(c,REQ_PEROXIDE)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.negcon)
	e4:SetCost(s.negcost)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
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
		and s.meta_mask(c,fc,REQ_PEROXIDE)>0
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
-- ② 战斗破坏耐性 / 守备攻击
--==============================
function s.indtg(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end

--==============================
-- ③ 怪兽效果发动无效
--==============================
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
