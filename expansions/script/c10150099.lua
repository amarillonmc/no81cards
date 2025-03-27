--No.62 超银河眼光子龙皇
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150099)
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	local e1=rsef.SV_CANNOT_BE_MATERIAL(c,"xyz")
	local e2=rsef.STO(c,EVENT_ATTACK_ANNOUNCE,{m,1},nil,"dis,atk",nil,cm.atkcon,rscost.rmxyz(2),cm.atktg,cm.atkop)
end
aux.xyz_number[10150099]=62
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ) and c:IsRank(8)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return tc and aux.disfilter1(tc) and tc:IsCanOverlay() and c:IsChainAttackable(0,true)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
end
function cm.atkop(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard(Card.IsFaceup)
	if tc then
		local e1,e2=rscf.QuickBuff({c,tc},"dis,dise",1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e3=rscf.QuickBuff(c,"atk+",500)
			local e4=rsef.SC(c,EVENT_BATTLED,nil,nil,"cd",nil,cm.xyzop,rsreset.est+RESET_PHASE+PHASE_BATTLE+PHASE_END)
			e4:SetLabelObject(tc)
			e4:SetLabel(c:GetAttackAnnouncedCount())
		end
	end
end
function cm.xyzop(e,tp)
	e:Reset()
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if e:GetLabel()==c:GetAttackAnnouncedCount() and bc==e:GetLabelObject() and bc:IsCanOverlay() and c:IsType(TYPE_XYZ) and not bc:IsImmuneToEffect(e) and bc:IsRelateToBattle() and c:IsRelateToBattle() then
		Duel.Hint(HINT_CARD,0,m)
		local og=bc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rsgf.Mix2(bc))
		Duel.ChainAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end