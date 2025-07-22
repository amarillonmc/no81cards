--有相幻兽 奇美拉
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(s.Chimera_Fusion_Condition())
	e0:SetOperation(s.Chimera_Fusion_Operation())
	--c:RegisterEffect(e0)
	aux.AddFusionProcFunRep2(c,s.matfilter,2,99,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.sumcon)
	e3:SetOperation(s.sucop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(s.indct)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end
function s.matfilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.Chimera_Fusion_Gcheck(g,fc,tp,chkf,gc)
	if g:IsExists(aux.TuneMagicianCheckX,1,nil,g,EFFECT_TUNE_MAGICIAN_F) then return false end
	if gc and not g:IsContains(gc) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then return false end
	return g:GetClassCount(Card.GetFusionCode)==g:GetCount()
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function s.Chimera_Fusion_Condition()
	return function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			if gc then
				if not g:IsContains(gc) then return false end
				return g:IsExists(s.Alba_System_Drugmata_Fusion_Filter,1,nil,g,fc,tp,chkf,gc)
			end
			return g:CheckSubGroup(s.Chimera_Fusion_Gcheck,3,99,fc,tp,chkf,gc)
		end
end
function s.Chimera_Fusion_Operation()
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			local fg=eg:Clone()
			aux.GCheckAdditional=aux.dncheck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			sg=eg:SelectSubGroup(tp,s.Chimera_Fusion_Gcheck,true,3,99,fc,tp,chkf)
			aux.GCheckAdditional=nil
			Duel.SetFusionMaterial(sg)
		end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc,dr=e:GetLabel()
	if chk==0 then return dr and gc>=5 and Duel.IsPlayerCanDraw(tp,dr) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,dr,tp,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dr)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local gc,dr=e:GetLabel()
	Duel.Draw(tp,dr,REASON_EFFECT)
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	local gc=mg:GetCount()
	local dr=mg:GetClassCount(Card.GetRace)
	e:GetLabelObject():SetLabel(gc,dr)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetMaterialCount()*300
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function s.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAttackBelow,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsAttackBelow,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack())
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end